module OpenBuildServiceAPI
  class Connection
    attr_reader :api_endpoint

    def initialize(username, password, opts = {})
      @username = username
      @password = password
      @api_endpoint = opts[:api_endpoint] ? opts[:api_endpoint] : 'https://api.opensuse.org'
      @request_timeout = opts[:request_timeout] ? opts[:request_timeout].to_i : 10
      @ca_file = opts[:ca_file]

      # send a simple request to test authentication - it raises an exception if the credentials are wrong
      send_request(:get, '/')
    end

    def send_request(method, path, params = {})
      request_body = params[:request_body] if params[:request_body]
      params.delete(:request_body)

      path = "/#{path}" unless path.start_with?('/')

      request_params = "?#{format_params(params)}" unless format_params(params).empty?
      uri = URI("#{@api_endpoint}#{path}#{request_params}")

      begin
        request = Net::HTTP.start(uri.host, uri.port, use_ssl: (uri.scheme == 'https'), open_timeout: @request_timeout, ca_file: @ca_file)

        if method.to_s.downcase == 'post'
          request_method = Net::HTTP::Post.new(uri)
        elsif method.to_s.downcase == 'put'
          request_method = Net::HTTP::Put.new(uri)
        elsif method.to_s.downcase == 'get'
          request_method = Net::HTTP::Get.new(uri)
        end

        request_method['Accept'] = 'application/xml'
        request_method['User-Agent'] = "open-build-service-api (Ruby Gem Version: #{OpenBuildServiceAPI::VERSION})"

        request_method.basic_auth(@username, @password)
        request_method.body = request_body if request_body

        response = request.request(request_method)

        raise InternalServerError.new(response) if response.is_a?(Net::HTTPInternalServerError)
        raise NotFoundError.new(response) if response.is_a?(Net::HTTPNotFound)
        raise PermissionDeniedError.new(response) if response.is_a?(Net::HTTPForbidden)
        raise AuthenticationError.new(response, "Authentication failed. Please check your credentials.") if response.is_a?(Net::HTTPUnauthorized)

        return response
      rescue Errno::ECONNREFUSED, SocketError, Net::OpenTimeout => err
        raise ConnectionError.new(err.to_s)
      end
    end

    def about
      return @ref_about if @ref_about
      @ref_about = API::About.new(self)
    end

    def projects
      return @ref_projects if @ref_projects
      @ref_projects = API::Projects.new(self)
    end

    private

    def format_params(params)
      values = params.values
      formatted_params = ""

      params.keys.each_with_index do |param, index|
        formatted_params += "&" if index != 0

        if values[index].is_a?(Array)
          values[index].each do |array_value|
            formatted_params += '&' if formatted_params[-1] != '&' && formatted_params.length > 0
            formatted_params += "#{CGI.escape(param.to_s)}[]=#{CGI.escape(array_value.to_s)}"
          end
        else
          formatted_params += "#{CGI.escape(param.to_s)}=#{CGI.escape(values[index].to_s)}"
        end
      end

      formatted_params
    end
  end
end
