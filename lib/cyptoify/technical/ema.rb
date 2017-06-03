module Cyptoify
  module Technical
    class Ema
      #SMA: 10 period sum / 10
      #Multiplier: (2 / (Time periods + 1) ) = (2 / (10 + 1) ) = 0.1818 (18.18%)
      #EMA: {Close - EMA(previous day)} x multiplier + EMA(previous day).
     attr_accessor :time_period, :ema,

      def initialize(**args)
         @time_period = args[:time_period] || 12
         @close_price = args[:close_price]
         @previous_close_price = args[:previous_close_price]
      end

      def Ema
        @data.each_daily do |price|

        end
      end

    end
  end
end
