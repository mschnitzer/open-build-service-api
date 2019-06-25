module OpenBuildServiceAPI
  class Package
    attr_reader :name
    attr_accessor :project

    def initialize(params = {})
      @name = params[:name]
      @project = params[:project]
      @connection = params[:connection]
    end

    def to_s
      @name
    end

    def title
      title = meta.xpath('//package/title')
      title.empty? ? nil : title[0].text
    end

    def description
      description = meta.xpath('//package/description')
      description.empty? ? nil : description[0].text
    end

    def meta(opts = {})
      if !@cached_meta || @meta_reload
        @cached_meta = @connection.send_request(:get, "/source/#{CGI.escape(@project.name)}/#{CGI.escape(@name)}/_meta").body
        @meta_reload = false
      end

      if opts[:no_parse]
        @cached_meta
      else
        Nokogiri::XML(@cached_meta)
      end
    end

    def inspect
      "#<#{self.class.name}:#{"0x00%x" % (object_id << 1)} @name=\"#{@name}\", @project=\"#{@project.name}\">"
    end

    def rebuild!(repository=nil, arch=nil)
      @connection.send_request(:post, "/build/#{CGI.escape(@project.name)}", cmd: :rebuild, package: @name, repository: repository, arch: arch)
      true
    end

    def rebuild_failed!
      @connection.send_request(:post, "/build/#{CGI.escape(@project.name)}", cmd: :rebuild, package: @name, code: :failed)
      true
    end

    def delete!(message=nil)
      begin
        @connection.send_request(:delete, "/source/#{CGI.escape(@project.name)}/#{CGI.escape(@name)}", comment: message)
      rescue RequestError => err
        raise PackageDeletionPermissionError.new("No permission to delete package '#{@name}' in project " \
                                                 "'#{@project.name}'.") if err.error_code == 'delete_package_no_permission'
        raise
      end

      true
    end

    def reload!
      @meta_reload = true
    end
  end
end
