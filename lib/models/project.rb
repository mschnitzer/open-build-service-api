module OpenBuildServiceAPI
  class Project
    attr_accessor :name, :projects

    def initialize(params = {})
      @name = params[:name]
      @projects = params[:projects]
    end

    def to_s
      @name
    end
  end
end
