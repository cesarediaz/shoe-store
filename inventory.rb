# frozen_string_literal: true

require 'json'
require 'redis'

# Inventory class
class Inventory
  MINIMUM = 0..9
  MEDIUM = 10..49
  HIGH = 50..100
  AVG_STOCK = 30

  def initialize(db, attribute)
    @attribute = JSON.parse(attribute)
    @redis = db
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
    stock_in_houses.each { |house| houses << house.split(':')[0] if @redis.get(house).to_i < AVG_STOCK }
    @redis.set("#{store}:#{model}", inventory)
    houses
  end
end
