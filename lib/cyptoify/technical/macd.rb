module Cyptoify
  module Technical
    class Macd < Cyptoify::Technical::Technical
      attr_accessor :fast_ema, :slow_ema

      def post_initialize(args)
        @fast_ema = Cyptoify::Technical::Ema.new(time_period: 12,data: data)
        @slow_ema = Cyptoify::Technical::Ema.new(time_period: 26,data: data)
      end

      def each(&block)
        return enum_for(:each) unless block_given?
        macd { |p| block.call(p) }
      end

      private

      def macd
        fast_ema.each.inject({}) { |hsh, v| hsh.merge({ v[:date] => v[:ema] }) }
        slow_ema.each do |ema|
          next unless fast_ema[ema[:date]]
          yield ({ date: ema[:date], macd: (fast_ema[ema[:date]] - ema[:ema]).round(2) })
        end
    end
   end
  end
end
