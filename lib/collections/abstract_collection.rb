module OpenBuildServiceAPI
  class AbstractCollection
    include Enumerable
    extend Forwardable

    def_delegators :@data, :each, :count, :empty?

    def inspect
      count = 1
      output = '['

      @data.each do |item|
        if count == 30
          output += item.to_s
          output += ", ..." if @data.count > 30

          break
        else
          output += "#{item}, "
          count += 1
        end
      end

      output += ']'
    end
  end
end
