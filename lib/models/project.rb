module OpenBuildServiceAPI
  class Project
    attr_accessor :name, :projects, :packages

    def initialize(params = {})
      @name = params[:name]
      @projects = params[:projects]
      @packages = params[:packages]
    end

    def to_s
      @name
    end
  end
end
