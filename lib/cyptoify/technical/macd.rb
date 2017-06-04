module Cyptoify
  module Technical
    class Macd < Cyptoify::Technical::Technical
      attr_accessor :fast_ema, :slow_ema
      #MACD Line: (q)
      #Signal Line: 9-day EMA of MACD Line
      #MACD Histogram: MACD Line - Signal Line
      def initialize
        @fast_ema = Cyptoify::Technical::Ema.new.each.inject({}){|hsh,v| hsh.merge({v[:date] => v[:ema]})}
        @slow_ema = Cyptoify::Technical::Ema.new(time_period: 26)
      end
      def each(&block)
        return enum_for(:each) unless block_given?
        macd{|p|block.call(p)}
      end

       private
      def macd
         slow_ema.each do |ema|
           yield ({date: ema[:date], macd: (fast_ema[ema[:date]] - ema[:ema]).round(2)})
      end
    end
   end
  end
end
