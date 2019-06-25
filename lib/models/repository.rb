module OpenBuildServiceAPI
  class Repository
    attr_accessor :name, :project

    def initialize(params = {})
      @name = params[:name]
      @paths = params[:paths]
      @architectures = params[:architectures]
      @project = params[:project]
      @connection = params[:connection]
    end

    def to_s
      @name
    end

    def paths
      @paths
    end

    def architectures
      @architectures
    end
  end
end
