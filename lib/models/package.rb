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
  end
end
