module Cyptoify
  module Technical
    require 'pry'

    class Technical

      include Enumerable

      def initialize(**args)
        file_name = args[:file_name] || 'price.json'
        @data = args[:data] || Data.new(file_name: file_name)
        
        post_initialize(args)
      end

      def post_initialize(args)
        nil
      end

      def data
          @data
      end
    end
  end
end
