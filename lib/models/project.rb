module OpenBuildServiceAPI
  class Project
    attr_accessor :name, :projects

    def initialize(params = {})
      @name = params[:name]
      @projects = params[:projects]
      @connection = params[:connection]
    end

    def to_s
      @name
    end

    def packages
      return @cached_packages if @cached_packages && !@package_reload
      @package_reload = false
      @cached_packages = []

      packages = Nokogiri::XML(@connection.send_request(:get, "/source/#{CGI.escape(@name)}").body)
      packages.xpath('//entry').each do |package|
        @cached_packages << Package.new(name: package.attr('name'), connection: @connection, project: self)
      end

      @cached_packages
    end

    def reload!
      @package_reload = true
    end
  end
end
