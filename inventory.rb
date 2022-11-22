# frozen_string_literal: true

require 'json'

# Inventory class
class Inventory
  MINIMUM = 0..9
  MEDIUM = 10..49
  HIGH = 50..100

  def initialize(attribute)
    @attribute = JSON.parse(attribute)
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

end
