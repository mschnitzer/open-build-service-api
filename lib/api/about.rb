module OpenBuildServiceAPI
  module API
    class About
      attr_reader :title, :description, :revision, :last_deployment, :commit

      def initialize(connection)
        @connection = connection
        reload!
      end

      def reload!
        response = @connection.send_request(:get, '/about')
        data = Nokogiri::XML(response.body)

        @title = data.xpath('//about/title').text
        @description = data.xpath('//about/description').text
        @revision = data.xpath('//about/revision').text
        @commit = data.xpath('//about/commit').text

        begin
          @last_deployment = DateTime.parse(data.xpath('//about/last_deployment').text)
        rescue ArgumentError
          @last_deployment = nil
        end

        true
      end
    end
  end
end
