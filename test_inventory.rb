require "minitest/autorun"
require './inventory.rb'

class TestInventory < Minitest::Test
  def setup
    @inventory = Inventory.new({
      'store' => 'ALDO Crossgates Mall',
      'model' => 'CAELAN',
      'inventory' => 29
    })
  end

  def test_store
    assert_equal @inventory.store, 'ALDO Crossgates Mall'
  end
end
