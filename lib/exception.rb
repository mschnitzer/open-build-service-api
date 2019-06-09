module OpenBuildServiceAPI
  # remote API network errors
  class RemoteAPIError < Exception
    attr_accessor :response, :message, :error_code, :error_summary

    def initialize(response, message=nil)
      response_body = response.body

      @response = response
      @message = message ? message : response_body

      response_xml = Nokogiri::XML(response_body)
      status = response_xml.xpath('./status')[0]

      if status
        @error_code = status.attr('code')

        summary = status.xpath('./summary')
        @error_summary = summary.text if summary[0]
      end
    end

    def to_s
      @message
    end
  end

  class InternalServerError < RemoteAPIError; end
  class AuthenticationError < RemoteAPIError; end
  class NotFoundError < RemoteAPIError; end
  class PermissionDeniedError < RemoteAPIError; end

  # remote API errors
  class APIError < Exception; end
  class ProjectNotFoundError < APIError; end
  class ProjectCreationPermissionError < APIError; end
  class ProjectCreationFailedError < APIError; end

  # library specific exceptions
  class GeneralError < Exception; end
  class ConnectionError < GeneralError; end
  class InvalidHTTPMethodWithBody < GeneralError; end
end
