require "cyptoify/version"
require "cyptoify/technical/ema"
require "cyptoify/technical/data"

require 'json'
require 'date'

module Cyptoify
  
  def data
    @data ||= Data.new({file: 'price.json'})
  end
end
