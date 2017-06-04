module Cyptoify
  module Technical
    class Technical
      include Enumerable

      def data
        @data||=Data.new({file: 'price.json'})
      end
    end
  end
end
