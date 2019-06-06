module OpenBuildServiceAPI
  # remote API network errors
  class RemoteAPIError < Exception
    attr_accessor :response, :message

    def initialize(response, message=nil)
      @response = response
      @message = message ? message : response.body
    end

    def to_s
      @message
    end
  end

  class InternalServerError < RemoteAPIError; end
  class AuthenticationError < RemoteAPIError; end
  class NotFoundError < RemoteAPIError; end

  # remote API errors
  class APIError < Exception; end
  class ProjectNotFoundError < APIError; end

  # library specific exceptions
  class GeneralError < Exception; end
  class ConnectionError < GeneralError; end
  class InvalidHTTPMethodWithBody < GeneralError; end
end
