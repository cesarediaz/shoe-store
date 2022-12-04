# frozen_string_literal: true

require 'json'
require 'redis'

# Inventory class
class Inventory
  MINIMUM = 0..9
  MEDIUM = 10..49
  HIGH = 50..100
  AVG_STOCK = 99

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
    stock_in_houses.each do |house|
      next unless @redis.get(house).to_i < AVG_STOCK

      houses << [house.split(':')[0], @redis.get(house).to_i]
    end
    @redis.set("#{store}:#{model}", inventory)
    houses.sort_by { |array| array[1] }
  end
end
