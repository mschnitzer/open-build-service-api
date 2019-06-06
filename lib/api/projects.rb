module OpenBuildServiceAPI
  module API
    class Projects
      def initialize(connection)
        @connection = connection
      end

      def list
        projects = Nokogiri::XML(@connection.send_request(:get, '/source').body)
        projects.xpath('//entry').map {|project| Project.new(projects: self, name: project.attr('name')) }
      end
    end
  end
end
