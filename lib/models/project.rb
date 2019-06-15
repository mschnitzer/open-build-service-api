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

    def branch_package(source_project, source_package, package_name_after_branch=nil)
      params = { cmd: 'branch', target_project: name }
      params[:target_package] = package_name_after_branch ? package_name_after_branch : source_package

      begin
        response = @connection.send_request(:post, "/source/#{CGI.escape(source_project.to_s)}/#{CGI.escape(source_package.to_s)}", params)
        response_xml = Nokogiri::XML(response.body)

        @package_reload = true
        Package.new(name: response_xml.xpath('//data[@name="targetpackage"]')[0].text, connection: @connection, project: self)
      rescue RequestError => err
        raise PackageAlreadyExistsError.new("Package '#{params[:target_package]}' does already exist " \
                                            "in project '#{@name}'.") if err.error_code == 'double_branch_package'
        raise TargetProjectPermissionError.new("Branching to project '#{@name}' is not possible: No " \
                                               "access in target project.") if err.error_code == 'cmd_execution_no_permission'
        raise
      end
    end

    def reload!
      @package_reload = true
    end
  end
end
