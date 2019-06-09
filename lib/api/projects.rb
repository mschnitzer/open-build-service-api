module OpenBuildServiceAPI
  module API
    class Projects
      def initialize(connection)
        @connection = connection
      end

      def create(name, meta = nil)
        raise ProjectAlreadyExistsError.new("Project name '#{name}' has already been taken.") if exists?(name)

        meta = meta ? meta : meta_for_new_project(name)

        begin
          response = @connection.send_request(:put, "/source/#{CGI.escape(name)}/_meta", request_body: meta)
        rescue PermissionDeniedError => err
          raise ProjectCreationPermissionError.new(err.error_summary) if err.error_code == 'create_project_no_permission'
          raise
        end

        return Project.new(projects: self, name: name) if response.is_a?(Net::HTTPOK)
        raise ProjectCreationFailedError.new("could not create project. API responded with '#{response.code}': #{response.body}")
      end

      def list
        projects = Nokogiri::XML(@connection.send_request(:get, '/source').body)
        projects.xpath('//entry').map {|project| Project.new(projects: self, name: project.attr('name')) }
      end

      def exists?(name)
        !!find(name)
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

      private

      def meta_for_new_project(name)
        project_meta = Nokogiri::XML::Builder.new do |xml|
          xml.project('name': name) do
            xml.title name
            xml.description
          end
        end

        project_meta.to_xml
      end
    end
  end
end
