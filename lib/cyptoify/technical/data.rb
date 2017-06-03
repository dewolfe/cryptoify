module Cyptoify
  module Technical
    class Data
      include Enumerable
      attr_accessor :price_set

      def initialize(**args)
        @file=(File.read(args[:file]))
        @price_set=JSON.parse(@file)["data"]
        @grain = args[:grain] || :daily
      end

      def each(&block)
        send("each_#{@grain.to_s}"){|p|block.call(p)}
      end

      def find_close(date)
        select_for_date{|d|d == date}
      end

      def select_for_date
        @data.each{|data| yield DateTime.parse(data) }
      end

      def price_set_in_days(**args)


      end


private

def each_daily
  current_date = DateTime.parse(@price_set.first["time"]).to_date
  current_date_time = DateTime.parse(@price_set.first["time"])
  current_price = 0.00
  @price_set.each do |price|
    this_date_time = DateTime.parse(price["time"])
    if current_date == this_date_time.to_date
      current_price = price["usd"] if current_date_time <= this_date_time
    else
      yield ({date: current_date, usd: current_price})
      current_date = this_date_time.to_date
    end
  end
end



    end

  end
end
