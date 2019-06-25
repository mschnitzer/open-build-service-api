module OpenBuildServiceAPI
  class SourcesCollection < AbstractCollection
    attr_accessor :package

    def initialize(params = {})
      raise ArgumentError.new('The dataset needs to be provided as an Array.') if params[:data] && !params[:data].is_a?(Array)

      @connection = params[:connection]
      @package = params[:package]
      @data = params[:data] ? params[:data] : []
    end
  end
end
