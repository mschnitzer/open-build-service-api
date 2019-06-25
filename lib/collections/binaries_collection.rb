module OpenBuildServiceAPI
  class BinariesCollection < AbstractCollection
    attr_accessor :package

    def initialize(params = {})
      raise ArgumentError.new('The dataset needs to be provided as an Array.') if params[:data] && !params[:data].is_a?(Array)

      @connection = params[:connection]
      @package = params[:package]
      @data = params[:data] ? params[:data] : []
    end

    def delete_all!
      @connection.send_request(:post, "/build/#{CGI.escape(@package.project.name)}", cmd: :wipe, package: @package.name)
      true
    end
  end
end
