module Cyptoify
  module Technical
    class Ema < Cyptoify::Technical::Technical
      #SMA: 10 period sum / 10
      #Multiplier: (2 / (Time periods + 1) ) = (2 / (10 + 1) ) = 0.1818 (18.18%)
      #EMA: {Close - EMA(previous day)} x multiplier + EMA(previous day).
     attr_accessor :time_period, :ema,

      def initialize(**args)
         @time_period = args[:time_period].to_i || 12
         @close_price = args[:close_price]
         @previous_close_price = args[:previous_close_price]
      end

      def ema
        @data.each_daily do |price|
            @data
        end
      end

      def sma(period=10)
        binding.pry
        data.each.first(period).inject(0.00){|sum,price| sum += price[:usd]}/period
      end
   end
 end
end
