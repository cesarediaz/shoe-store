require 'json'

class Inventory
  MINIMUM = 0..9
  MEDIUM = 10..500
  HIGH = 501..999
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
