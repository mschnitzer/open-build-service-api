module OpenBuildServiceAPI
  class PackagesCollection < AbstractCollection
    def initialize(params = {})
      raise ArgumentError.new('The dataset needs to be provided as an Array.') if params[:data] && !params[:data].is_a?(Array)

      @connection = params[:connection]
      @project = params[:project]
      @data = params[:data] ? params[:data] : []
    end

    def exists?(name)
      !!find(name)
    end

    def find(name)
      begin
        package_data = Nokogiri::XML(@connection.send_request(:get, "/source/#{CGI.escape(@project.name)}/#{name}").body)
        Package.new(name: package_data.root.attr('name'), connection: @connection, project: @project)
      rescue RequestError => err
        return if err.error_code == 'unknown_package'
        raise
      end
    end

    def find!(name)
      package = find(name)

      raise PackageNotFoundError.new("Package '#{name}' does not exist in project '#{@project.name}'.") unless package
      package
    end
  end
end
