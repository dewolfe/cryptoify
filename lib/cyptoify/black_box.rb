module Cyptoify
  class BlackBox < Cyptoify::Technical::Technical
    require 'rest-client'
    attr_accessor :quad_client, :indicator, :signal, :book, :today,:trade_today

    def initialize(**args)
      @quad_client = QuadrigaCX::Client.new
      @book = args[:book] || 'eth_cad'
      @indicator = args[:indicator] || Technical::Macd.new
      @signal = args[:signal] || Technical::MacdSignal.new
      @trade_today = false
    end

    def call
      set_today
      data.refresh_data
      loop do
        check_today
        puts "Trade today? #{trade_today}"
        puts 'Checking Signal'
        case check_signal
          when :buy
            puts 'STRAGEITY: BUY!'
            quad_buy
          when :sell
            puts 'STRAGEITY: SELL!'
            quad_sell
          when :hold
            puts 'STRAGEITY: Hold'
        end
        sleep 3600
        data.refresh_data
      end
    rescue Exception => e
      puts "Exiting #{e}"
    end

    private

    def check_signal
      today = DateTime.now.to_date
      yesturday = today - 1
      ind_today = indicator.select { |d| d[:date] == today }.first[:macd]
      signal_today = signal.select { |d| d[:date] == today }.first[:macd_signal]
      ind_yesturday = indicator.select { |d| d[:date] == yesturday }.first[:macd]
      signal_yesturday = signal.select { |d| d[:date] == yesturday }.first[:macd_signal]
      puts "Today histogram: #{ind_today - signal_today}"
      puts "Yesturday histogram: #{ind_yesturday - signal_yesturday}"
      if ((ind_today - signal_today) < 0) && ((ind_yesturday - signal_yesturday) > 0)
        :buy
      elsif ((ind_today - signal_today) > 0) && ((ind_yesturday - signal_yesturday) < 0)
        :sell
      else
        :hold
      end
    end

    def set_today
      self.today ||= DateTime.new.to_date
    end

    def check_today
      now=DateTime.new.to_date
      unless self.today == now
        put "Reseting trades."
        self.today = now
        self.trade_today = false
      end
    end

    def quad_buy
      return if trade_today
      cancel_all_orders
      quad_client.maket_buy(amount: cad_balance, book: book)
      self.trade_today = true
      Cyptoify::Notify.send_notification('Buy signal fired.')

    end

    def quad_sell
      return if trade_today
      cancel_all_orders
      quad_client.maket_sell(amount: eth_ballance, book: book)
      self.trade_today = true
      Cyptoify::Notify.send_notification('Sell signal fired.')
    end

    def cancel_all_orders
      orders = quad_client.open_orders(book: book).map(&:id)
      orders.each { |order| quad_client.cancel(id: order) }
    end

    def cad_balance
      quad_client.balance.cad_balance
    end

    def eth_ballance
      quad_client.balance.eth_ballance
    end
  end
  # code
end
