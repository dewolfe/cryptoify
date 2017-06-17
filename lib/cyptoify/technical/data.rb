module Cyptoify
  module Technical
    class Data
      include Enumerable
      require 'rest-client'

      attr_accessor :price_set, :time_stamp

      def initialize(**args)
        @file_name = args[:file] || 'price.json'
        @grain = args[:grain] || :daily
        @time_stamp = DateTime.now
      end

      def each()
        return enum_for(:each) unless block_given?
        send("each_#{@grain}") { |p| yield(p) }
      end

      def refresh_data
        puts 'Refreshing Data'
        load_data_from_etherchain
        @file = File.read(@file_name)
        self.price_set = JSON.parse(@file)['data']
      end

      private

      def load_data_from_etherchain
        file = File.open('price.json', 'w')
        begin
        request = RestClient.get('https://etherchain.org/api/statistics/price')
        file.write(request.body)

      rescue Exception => e
        puts "Error while loading data from EtherChain \n #{e}"
      end

      end

      def each_daily
        current_date = DateTime.parse(@price_set.first['time']).to_date
        current_date_time = DateTime.parse(@price_set.first['time'])
        current_price = 0.00
        @price_set.each do |price|
          this_date_time = DateTime.parse(price['time'])
          if current_date == this_date_time.to_date
            current_price = price['usd'] if current_date_time <= this_date_time
          else
            yield { date: current_date, usd: current_price }
            current_date = this_date_time.to_date
          end
        end
        yield { date: current_date, usd: current_price }
      end
    end
  end
end
