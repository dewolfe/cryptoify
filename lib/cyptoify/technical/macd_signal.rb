module Cyptoify
  module Technical
    class MacdSignal < Cyptoify::Technical::Technical
      attr_accessor :macd
      # MACD Line: (12-day EMA - 26-day EMA)
      # Signal Line: 9-day EMA of MACD Line
      # MACD Histogram: MACD Line - Signal Line
      def post_initialize(**args)
        @time_period = args[:time_period] || 9
        @macd = Cyptoify::Technical::Macd.new(data: data)
      end

      def each()
        return enum_for(:each) unless block_given?
        macd_signal { |p| yield(p) }
      end

      private 

      def macd_signal
        previous_day = sma(@time_period)
        multiplier = (2.0 / (@time_period + 1))
        count = 0
        macd.each do |price|
          count += 1; next unless count > @time_period
          em = ((price[:macd] - previous_day) * multiplier + previous_day).round(2)
          yield ({ date: price[:date], macd_signal: em })
          previous_day = em
        end
      end

      def sma(period = 9)
        (macd.each.first(period).inject(0.00) { |sum, price| sum += price[:macd] } / period).round(2)
      end
    end
   end
  end
