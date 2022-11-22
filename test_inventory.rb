# frozen_string_literal: true

require 'minitest/autorun'
require './inventory'

# Inventory test classs
class TestInventory < Minitest::Test
  def setup
    @data = '{"store":"ALDO Crossgates Mall","model":"CAELAN","inventory":29}'
    @inventory = Inventory.new(@data)
  end

  def test_store
    assert_equal @inventory.store, 'ALDO Crossgates Mall'
  end

  def test_model
    assert_equal @inventory.model, 'CAELAN'
  end

  def test_inventory
    assert_equal @inventory.inventory, 29
  end

  def test_minimum_stock_qty
    @data = '{"store":"ALDO Crossgates Mall","model":"CAELAN","inventory":9}'
    @inventory = Inventory.new(@data)

    assert_equal @inventory.alert, :minimum
  end

  def test_medium_stock_qty
    @data = '{"store":"ALDO Crossgates Mall","model":"CAELAN","inventory":30}'
    @inventory = Inventory.new(@data)

    assert_equal @inventory.alert, :medium
  end

  def test_high_stock_qty
    @data = '{"store":"ALDO Crossgates Mall","model":"CAELAN","inventory":55}'
    @inventory = Inventory.new(@data)

    assert_equal @inventory.alert, :high
  end
end
