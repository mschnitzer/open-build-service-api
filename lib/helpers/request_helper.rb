module OpenBuildServiceAPI
  module RequestHelper
    def self.parse_data(xml_data, params = {})
      state_element = xml_data.xpath('./state')[0]

      Request.new(
        id:         xml_data.attr('id').to_i,
        creator:    xml_data.attr('creator'),
        state:      state_element.attr('name'),
        project:    params[:project],
        connection: params[:connection]
      )
    end
  end
end
