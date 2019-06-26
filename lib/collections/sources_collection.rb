module OpenBuildServiceAPI
  class SourcesCollection < AbstractCollection
    attr_accessor :package

    def initialize(params = {})
      raise ArgumentError.new('The dataset needs to be provided as an Array.') if params[:data] && !params[:data].is_a?(Array)

      @connection = params[:connection]
      @package = params[:package]
      @data = params[:data] ? params[:data] : []
    end

    def find(source_name)
      _find_by(:name, source_name)
    end

    def find!(source_name)
      source = find(source_name)
      raise SourceNotFoundError.new("Source '#{source_name}' (source name) was not found in '#{@package.project.name}/#{@package.name}'.") unless source

      source
    end

    def find_by_md5_hash(md5_hash)
      _find_by(:md5_hash, md5_hash)
    end

    def find_by_md5_hash!(md5_hash)
      source = find_by_md5_hash(md5_hash)
      raise SourceNotFoundError.new("Source '#{md5_hash}' (md5 hash) was not found in '#{@package.project.name}/#{@package.name}'.") unless source

      source
    end

    private

    def _find_by(attribute, value)
      @data.each do |source|
        if (attribute == :name && source.name == value) || (attribute == :md5_hash && source.md5_hash == value)
          return source
        end
      end

      nil
    end
  end
end
