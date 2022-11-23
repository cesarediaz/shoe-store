# frozen_string_literal: true

require 'json'
require 'redis'

# Inventory class
class Inventory
  MINIMUM = 0..9
  MEDIUM = 10..49
  HIGH = 50..100

  def initialize(attribute)
    @attribute = JSON.parse(attribute)
    @redis = Redis.new
  end

  def store
    @attribute['store']
  end

  def model
    @attribute['model']
  end

  def inventory
    @attribute['inventory']
  end

  def alert
    case @attribute['inventory']
    when MINIMUM
      :minimum
    when MEDIUM
      :medium
    when HIGH
      :high
    end
  end

  def shoes_transfer
    return [] unless alert == :high

    houses = []
    stock_in_houses = @redis.keys("*#{model}")
    stock_in_houses.each { |house| houses << house.split(':')[0] if @redis.get(house).to_i < 10 }
    @redis.set("#{store}:#{model}", inventory)
    @redis.close
    houses
  end
end
