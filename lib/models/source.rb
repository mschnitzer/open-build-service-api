module OpenBuildServiceAPI
  class Source < AbstractModel
    attr_reader :name, :md5_hash, :size, :updated_at
    attr_accessor :package

    def initialize(params = {})
      @name = params[:name]
      @md5_hash = params[:md5_hash]
      @size = Filesize.from(params[:size])
      @updated_at = Time.at(params[:updated_at])
      @package = params[:package]
      @connection = params[:connection]
    end

    def to_s
      @name
    end

    def delete!
      @connection.send_request(:delete, "/source/#{CGI.escape(@package.project.name)}/#{CGI.escape(@package.name)}/#{CGI.escape(@name)}")
      true
    end
  end
end
