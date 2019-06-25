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
      return @title_updated if @title_updated

      title = meta.xpath('//package/title')
      title.empty? ? nil : title[0].text
    end

    def title=(value)
      @title_updated = value
    end

    def description
      return @description_updated if @description_updated

      description = meta.xpath('//package/description')
      description.empty? ? nil : description[0].text
    end

    def description=(value)
      @description_updated = value
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

    def save!
      @meta_reload = true
      meta_xml = meta

      meta_xml.xpath('//package/title')[0].content = @title_updated if @title_updated
      meta_xml.xpath('//package/description')[0].content = @description_updated if @description_updated

      @connection.send_request(:put, "/source/#{CGI.escape(@project.name)}/#{CGI.escape(@name)}/_meta", request_body: meta_xml.to_xml)

      # reset updated values
      @title_updated = nil
      @description_updated = nil

      # updated cached meta
      @cached_meta = meta_xml.to_xml

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
