require './lib/item'
require './lib/vendor'
require 'pry'
require 'minitest/autorun'
require 'minitest/pride'

class VendorTest<Minitest::Test

  def setup
    @item1 = Item.new({name: 'Peach', price: "$0.75"})
    @item2 = Item.new({name: 'Tomato', price: '$0.50'})
    @vendor = Vendor.new("Rocky Mountain Fresh")
  end

  def test_it_exists_and_has_a_name
    assert_instance_of Vendor, @vendor
    assert_equal ("Rocky Mountain Fresh"), @vendor.name
  end

  def test_it_has_no_inventory_can_check_stock_and_add_stock
    assert_equal ({}), @vendor.inventory
    assert_equal (0), @vendor.check_stock(@item1)
    @vendor.stock(@item1, 30)
    assert_equal ({@item1=> 30}), @vendor.inventory
    assert_equal (30), @vendor.check_stock(@item1)
    @vendor.stock(@item1, 25)
    assert_equal (55), @vendor.check_stock(@item1)
    @vendor.stock(@item2, 12)
    assert_equal ({@item1=> 55, @item2=> 12}), @vendor.inventory
  end

end
