require 'cyptoify/version'
require 'cyptoify/technical/technical'
require 'cyptoify/technical/ema'
require 'cyptoify/technical/data'
require 'cyptoify/technical/macd'
require 'cyptoify/technical/macd_signal'
require 'cyptoify/black_box'
require 'cyptoify/notify'

require 'json'
require 'date'
require 'dotenv/load'
require 'quadrigacx'

module Cyptoify
  class << self
    attr_accessor :configuration
  end

  def self.start
    Cyptoify.configure
    BlackBox.new.call
  end

  def self.configure
    QuadrigaCX.configure do |config|
      config.client_id  = ENV['QUADRIGACX_CLIENT_ID']
      config.api_key    = ENV['QUADRIGACX_API_KEY']
      config.api_secret = ENV['QUADRIGACX_API_SECRET']
    end
  end
end
