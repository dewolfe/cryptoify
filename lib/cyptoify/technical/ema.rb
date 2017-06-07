module Cyptoify
  module Technical
    class Ema < Cyptoify::Technical::Technical

      def post_initialize(args)
        @time_period = args[:time_period] || 12
      end

      def each()
        return enum_for(:each) unless block_given?
        ema { |p| yield(p) }
      end

      def ema
        previous_day=sma(@time_period)
        multiplier = (2.0 / (@time_period + 1))
        count = 0
        data.each do |price|
          count += 1; next unless count > @time_period
          em = ((price[:usd] - previous_day) * multiplier + previous_day).round(2)
          yield ({ date: price[:date], ema: em })
          previous_day = em
        end
      end

      def sma(period = 10)
        (data.each.first(period).inject(0.00) { |sum, price| sum += price[:usd] } / period).round(2)
      end
 end
end
end
