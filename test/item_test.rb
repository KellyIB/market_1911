require './lib/item'
require 'pry'
require 'minitest/autorun'
require 'minitest/pride'

class ItemTest<Minitest::Test

  def setup
    @item1 = Item.new({name: 'Peach', price: "$0.75"})
    @item2 = Item.new({name: 'Tomato', price: '$0.50'})
end

  def test_it_exists_and_has_a_name_and_price
    assert_instance_of Item, @item1
    assert_instance_of Item, @item2
    assert_equal ('Peach'), @item1.name
    assert_equal ("$0.75"), @item1.price
  end
end
