module OpenBuildServiceAPI
  class Binary
    attr_reader :name, :size, :created_at, :architecture
    attr_accessor :package

    def initialize(params = {})
      @name = params[:name]
      @size = Filesize.from(params[:size])
      @created_at = Time.at(params[:created_at])
      @architecture = params[:architecture]
      @package = params[:package]
      @connection = params[:connection]
    end

    def to_s
      @name
    end
  end
end
