require './lib/item'
require './lib/vendor'
require './lib/market'
require 'pry'
require 'minitest/autorun'
require 'minitest/pride'

class MarketTest<Minitest::Test

  def setup
    @market = Market.new("South Pearl Street Farmers Market")
    @vendor1 = Vendor.new("Rocky Mountain Fresh")
    @vendor2 = Vendor.new("Ba-Nom-a-Nom")
    @vendor3 = Vendor.new("Palisade Peach Shack")
    @item1 = Item.new({name: 'Peach', price: "$0.75"})
    @item2 = Item.new({name: 'Tomato', price: '$0.50'})
    @item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    @item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})
    @item5 = Item.new({name: 'Onion', price: '$0.25'})
end

  def test_it_exists_and_has_attributes
    assert_instance_of Market, @market
    assert_equal ("South Pearl Street Farmers Market"), @market.name
    assert_equal ([]), @market.vendors
  end

  def test_it_can_add_vendors_and_knows_their_names
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    assert_equal ([@vendor1, @vendor2, @vendor3]), @market.vendors
    assert_equal (["Rocky Mountain Fresh", "Ba-Nom-a-Nom", "Palisade Peach Shack"]),
    @market.vendor_names
  end

  def test_it_knows_what_items_its_vendors_sell
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    assert_equal ([@vendor1, @vendor3]), @market.vendors_that_sell(@item1)
    assert_equal ([@vendor2]), @market.vendors_that_sell(@item4)
  end

  def test_it_can_sort_items_from_all_vendors_alphabetically_and_can_list_quantities
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    assert_equal (["Banana Nice Cream", "Peach", "Peach-Raspberry Nice Cream", "Tomato"]),
    @market.sorted_item_list
    assert_equal ({@item4=>50, @item1=>100, @item3=>25, @item2=>7}), @market.total_inventory
  end

  def test_it_can_tell_if_the_market_doesnt_have_enough
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    assert_equal (false), @market.enough?(@item5, 100)
    assert_equal (true), @market.enough?(@item1, 100)
  end

  def test_it_can_sell_items_from_vendors_and_remove_from_stock
    @vendor1.stock(@item1, 35)
    @vendor1.stock(@item2, 7)
    @vendor2.stock(@item4, 50)
    @vendor2.stock(@item3, 25)
    @vendor3.stock(@item1, 65)
    @market.add_vendor(@vendor1)
    @market.add_vendor(@vendor2)
    @market.add_vendor(@vendor3)
    assert_equal (false), @market.sell(@item5, 1)
    assert_equal (false), @market.sell(@item5, 1)
    assert_equal (true), @market.sell(@item4, 5)
    assert_equal (45), @vendor2.check_stock(@item4)
    assert_equal (true), @market.sell(@item1, 40)
    assert_equal (0), @vendor1.check_stock(@item1)
    assert_equal (60), @vendor3.check_stock(@item1)
  end
end

# ## Iteration 4 - Selling Items
#
# Add a method to your Market class called `sell` that takes an item and a quantity as arguments. There are two possible outcomes of the `sell` method:
#
# 1. If the Market does not have enough of the item in stock to satisfy the given quantity, this method should return `false`.
#
# 2. If the Market's has enough of the item in stock to satisfy the given quantity, this method should return `true`. Additionally, this method should reduce the stock of the Vendors. It should look through the Vendors in the order they were added and sell the item from the first Vendor with that item in stock. If that Vendor does not have enough stock to satisfy the given quantity, the Vendor's entire stock of that item will be depleted, and the remaining quantity will be sold from the next vendor with that item in stock. It will follow this pattern until the entire quantity requested has been sold.
#
# For example, suppose vendor1 has 35 `peaches` and vendor3 has 65 `peaches`, and vendor1 was added to the market first. If the method `sell(<ItemXXX, @name = 'Peach'...>, 40)` is called, the method should return `true`, vendor1's new stock of `peaches` should be 0, and vendor3's new stock of `peaches` should be 60.
#
# Use TDD to update the `Market` class so that it responds to the following interaction pattern:
#
# ```ruby
# pry(main)> require './lib/item'
# #=> true
#
# pry(main)> require './lib/vendor'
# #=> true
#
# pry(main)> require './lib/market'
# #=> true
#
# pry(main)> item1 = Item.new({name: 'Peach', price: "$0.75"})
# #=> #<Item:0x007f9c56740d48...>
#
# pry(main)> item2 = Item.new({name: 'Tomato', price: '$0.50'})
# #=> #<Item:0x007f9c565c0ce8...>
#
# pry(main)> item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
# #=> #<Item:0x007f9c562a5f18...>
#
# pry(main)> item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})
# #=> #<Item:0x007f9c56343038...>
#
# pry(main)> item5 = Item.new({name: 'Onion', price: '$0.25'})
# #=> #<Item:0x007f9c561636c8...>
#
# pry(main)> market = Market.new("South Pearl Street Farmers Market")
# #=> #<Market:0x00007fe134933e20...>
#
# pry(main)> vendor1 = Vendor.new("Rocky Mountain Fresh")
# #=> #<Vendor:0x00007fe1348a1160...>
#
# pry(main)> vendor1.stock(item1, 35)
#
# pry(main)> vendor1.stock(item2, 7)
#
# pry(main)> vendor2 = Vendor.new("Ba-Nom-a-Nom")
# #=> #<Vendor:0x00007fe1349bed40...>
#
# pry(main)> vendor2.stock(item4, 50)
#
# pry(main)> vendor2.stock("Peach-Raspberry Nice Cream", 25)
#
# pry(main)> vendor3 = Vendor.new("Palisade Peach Shack")
# #=> #<Vendor:0x00007fe134910650...>
#
# pry(main)> vendor3.stock(item1, 65)
#
# pry(main)> market.add_vendor(vendor1)
#
# pry(main)> market.add_vendor(vendor2)
#
# pry(main)> market.add_vendor(vendor3)
#
# pry(main)> market.sell(item1, 200)
# #=> false
#
# pry(main)> market.sell(item5, 1)
# #=> false
#
# pry(main)> market.sell(item4, 5)
# #=> true
#
# pry(main)> vendor2.check_stock(item4)
# #=> 45
#
# pry(main)> market.sell(item1, 40)
# #=> true
#
# pry(main)> vendor1.check_stock(item1)
# #=> 0
#
# pry(main)> vendor3.check_stock(item1)
# #=> 60
# ```
