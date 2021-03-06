module Cyptoify
  class BlackBox < Cyptoify::Technical::Technical
    require 'rest-client'
    require 'pry'
    attr_accessor :quad_client, :indicator, :signal, :book, :today,:trade_today

    def post_initialize(args={})
      data.refresh_data
      @quad_client = QuadrigaCX::Client.new
      @book = args[:book] || 'eth_cad'
      @indicator = args[:indicator] || Technical::Macd.new(data: data)
      @signal = args[:signal] || Technical::MacdSignal.new(data: data)
      @today = set_today
      @trade_today = false

    end

    def call
      loop do
        check_today
        data.refresh_data
        puts "Cad Balance: #{cad_balance} Eth Ballance: #{eth_balance}"
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
      end
    rescue Exception => e
      puts "Exiting #{e}"
      puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
    end

    private

    def check_signal
      yesturday = today - 1
      ind_today = indicator.select { |d| d[:date] == today }.first
      signal_today = signal.select { |d| d[:date] == today }.first
      ind_yesturday = indicator.select { |d| d[:date] == yesturday }.first
      signal_yesturday = signal.select { |d| d[:date] == yesturday }.first
      return :hold unless (ind_today && signal_today && ind_yesturday && signal_yesturday)
      puts "Today histogram: #{(ind_today[:macd] - signal_today[:macd_signal]).round(2)}"
      puts "Yesturday histogram: #{(ind_yesturday[:macd] - signal_yesturday[:macd_signal]).round(2)}"
      if ((ind_today[:macd] - signal_today[:macd_signal]) > 0) &&
         ((ind_yesturday[:macd] - signal_yesturday[:macd_signal]) < 0)
        :buy
      elsif ((ind_today[:macd] - signal_today[:macd_signal]) < 0) &&
            ((ind_yesturday[:macd] - signal_yesturday[:macd_signal]) > 0)
        :sell
      else
        :hold
      end
    end

    def set_today
      unless today
        self.today = DateTime.now.to_date
        puts "Today is #{today}"

      end
    end

    def check_today
      now=DateTime.now.to_date
      unless self.today == now
        puts "New Day."
        self.today = now
        self.trade_today = false
      end
    end

    def quad_buy
      return if trade_today
      cancel_all_orders
      quad_client.market_buy(amount: cad_balance, book: book)
      self.trade_today = true
      Cyptoify::Notify.send_notification('Buy signal fired.')

    end

    def quad_sell
      return if trade_today
      cancel_all_orders
      Cyptoify::Notify.send_notification('Sell signal fired.')
      if eth_balance < 0.00000100
        puts "No eth to sell :-("
      else
      quad_client.market_sell(amount: eth_balance, book: book)
      end
      self.trade_today = true

    end

    def cancel_all_orders
      orders = quad_client.open_orders(book: book).map(&:id)
      orders.each { |order| quad_client.cancel(id: order) }
    end

    def cad_balance
      quad_client.balance.cad_balance.to_f
    end

    def eth_balance
      quad_client.balance.eth_balance.to_f
    end
  end
  # code
end
