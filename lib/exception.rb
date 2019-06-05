module OpenBuildServiceAPI
  # remote API errors
  class RemoteAPIError < Exception; end
  class InternalServerError < RemoteAPIError; end
  class AuthenticationError < RemoteAPIError; end

  # library specific exceptions
  class GeneralError < Exception; end
  class ConnectionError < GeneralError; end
  class InvalidHTTPMethodWithBody < GeneralError; end
end
