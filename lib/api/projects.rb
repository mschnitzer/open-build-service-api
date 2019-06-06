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

      def find(name)
        begin
          project_data = Nokogiri::XML(@connection.send_request(:get, "/source/#{CGI.escape(name)}").body)
          packages = project_data.xpath('//entry').map { |package| package.attr('name') }

          Project.new(projects: self, name: name, packages: packages)
        rescue NotFoundError
        end
      end

      def find!(name)
        project = find(name)

        raise ProjectNotFoundError.new("Project '#{name}' does not exist.") unless project
        project
      end
    end
  end
end
