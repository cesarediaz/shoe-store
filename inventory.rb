class Inventory
  def initialize(attribute)
    @attribute = attribute
  end

  def store
    @attribute['store']
  end
end
