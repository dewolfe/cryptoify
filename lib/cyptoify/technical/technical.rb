module Cyptoify
  module Technical
    class Technical
      def data
        @data||=Data.new({file: 'price.json'})
        
      end
    end
  end
end
