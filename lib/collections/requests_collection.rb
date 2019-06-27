module OpenBuildServiceAPI
  class RequestsCollection < AbstractCollection
    attr_accessor :project

    def initialize(params = {})
      raise ArgumentError.new('The dataset needs to be provided as an Array.') if params[:data] && !params[:data].is_a?(Array)

      @connection = params[:connection]
      @project = params[:project]
      @data = params[:data] ? params[:data] : []
    end
  end
end
