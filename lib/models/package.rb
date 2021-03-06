module OpenBuildServiceAPI
  class Package < AbstractModel
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
      @dirty = true
      @title_updated = value
    end

    def description
      return @description_updated if @description_updated

      description = meta.xpath('//package/description')
      description.empty? ? nil : description[0].text
    end

    def description=(value)
      @dirty = true
      @description_updated = value
    end

    def run_service!
      begin
        @connection.send_request(:post, "/source/#{CGI.escape(@project.name)}/#{CGI.escape(@name)}", cmd: :runservice)
      rescue RequestError => err
        if err.error_code == 'not_found' && err.error_summary =~ /no source service defined/
          raise NoSourceServiceDefinedError.new("Package '#{@name}' in project '#{@project.name}' has no source service defined.")
        end

        raise
      end

      true
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

    def sources
      return @cached_sources if @cached_sources && !@sources_reload
      collection_data = []

      response_xml = Nokogiri::XML(@connection.send_request(:get, "/source/#{CGI.escape(@project.name)}/#{CGI.escape(@name)}").body)
      response_xml.xpath('//entry').each do |file|
        collection_data << Source.new(
          name:       file.attr('name'),
          md5_hash:   file.attr('md5'),
          size:       file.attr('size'),
          updated_at: file.attr('mtime').to_i,
          package:    self,
          connection: @connection
        )
      end

      @sources_reload = false
      @cached_sources = SourcesCollection.new(data: collection_data, package: self, connection: @connection)
    end

    def binaries
      collection_data = []

      @project.repositories.each do |repository|
        binary_data = { repository: repository, binaries: [] }

        repository.architectures.each do |arch|
          begin
            response = @connection.send_request(:get, "/build/#{CGI.escape(@project.name)}/#{CGI.escape(repository.to_s)}/#{CGI.escape(arch)}/#{CGI.escape(@name)}")
            response_xml = Nokogiri::XML(response.body)

            response_xml.xpath('//binarylist/binary').each do |binary|
              file_name = binary.attr('filename')
              file_size = binary.attr('size')
              created_at = binary.attr('mtime').to_i

              if BinaryHelper.binary_file?(file_name)
                binary_data[:binaries] << Binary.new(
                  name:         file_name,
                  size:         file_size,
                  architecture: arch,
                  created_at:   created_at,
                  repository:   repository,
                  package:      self,
                  connection:   @connection
                )
              end
            end
          rescue RequestError => err
            # in case the repository does no longer exist, we can ignore it. there are no binaries anyways
            next if err.error_code == '404' && err.error_summary =~ /has no repository/

            # raise any other error
            raise
          end
        end

        collection_data << binary_data unless binary_data[:binaries].empty?
      end

      BinariesCollection.new(data: collection_data, connection: @connection, package: self)
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

    def dirty?
      !!@dirty
    end

    def save!
      return false unless @dirty

      @meta_reload = true
      meta_xml = meta

      meta_xml.xpath('//package/title')[0].content = @title_updated if @title_updated
      meta_xml.xpath('//package/description')[0].content = @description_updated if @description_updated

      # update meta definition
      @connection.send_request(:put, "/source/#{CGI.escape(@project.name)}/#{CGI.escape(@name)}/_meta", request_body: meta_xml.to_xml)

      # reset updated values
      @dirty = false

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
      @sources_reload = true
    end
  end
end
