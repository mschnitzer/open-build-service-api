module OpenBuildServiceAPI
  class Binary < AbstractModel
    attr_reader :name, :size, :created_at, :repository, :architecture, :local_file_path, :local_path
    attr_accessor :package

    def initialize(params = {})
      raise ArgumentError.new('repository needs to be an instance of OpenBuildServiceAPI::Repository') unless params[:repository].is_a?(Repository)

      @name = params[:name]
      @size = Filesize.from(params[:size])
      @created_at = Time.at(params[:created_at])
      @repository = params[:repository]
      @architecture = params[:architecture]
      @package = params[:package]
      @connection = params[:connection]
    end

    def to_s
      @name
    end

    def download(destination=nil)
      delete_local_copy!

      if destination
        raise InvalidDownloadDirectoryPath.new("Path '#{destination}' is not a directory.") unless File.directory?(destination)

        destination = destination[0..-2] if destination.end_with?('/')
        @tmp_dir = false
      else
        destination = Dir.mktmpdir('obs-binary-download')
        @tmp_dir = true
      end

      @local_file_path = "#{destination}/#{@name}"
      @local_path = destination

      response = @connection.send_request(:get, "/build/#{CGI.escape(@package.project.name)}/#{CGI.escape(@repository.to_s)}/" \
                                          "#{CGI.escape(@architecture)}/#{CGI.escape(@package.name)}/#{CGI.escape(@name)}")
      File.write(@local_file_path, response.body)
      @local_file_path
    end

    def delete_local_copy!
      return false unless @local_file_path
      return false unless File.exists?(@local_file_path)

      File.delete(@local_file_path)
      FileUtils.rm_r(@local_path) if Dir.empty?(@local_path) && @tmp_dir

      true
    end
  end
end
