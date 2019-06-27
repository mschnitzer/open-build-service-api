module OpenBuildServiceAPI
  class Request < AbstractModel
    attr_reader :id, :creator, :state
    attr_accessor :project

    def initialize(params = {})
      @id = params[:id]
      @creator = params[:creator]
      @state = params[:state]
      @project = params[:project]
      @connection = params[:connection]
    end

    def new?
      @state == 'new'
    end

    def declined?
      @state == 'declined'
    end

    def revoked?
      @state == 'revoked'
    end

    def superseded?
      @state == 'superseded'
    end

    def accepted?
      @state == 'accepted'
    end

    def review?
      @state == 'review'
    end
  end
end
