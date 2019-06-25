module OpenBuildServiceAPI
  class Source
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
  end
end
