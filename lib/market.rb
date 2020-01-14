require 'pry'

class Market
  attr_reader :name, :vendors

  def initialize(name)
    @name = name
    @vendors = []
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    the_vendor_names = @vendors.map do |vendor|
      vendor.name
    end
  end

  def vendors_that_sell(item)
    vendors.find_all do |vendor|
      vendor.inventory.keys.include?(item)
    end
  end

  def sorted_item_list
    market_items = vendors.map do |vendor|
      vendor.inventory.map do |item, amount|
        item.name
      end
    end
    market_items.flatten.sort.uniq
  end
  # vendor.inventory = hash of items and amount


  def total_inventory
    market_inventory = {}
     @vendors.each do |vendor|
      vendor.inventory.each do |item, amount|
        if market_inventory.keys.include?(item)
          market_inventory[item] += amount
        else
          market_inventory[item] = amount
        end
      end
    end
    market_inventory
  end

  end







# market_inventory = vendor.inventory.reduce ({}) do |acc, (item, amount)|
#   if acc.keys.include?(item.name)
#     acc[item.name] += amount
#   else
#     acc[item.name] = amount
#   end
#   acc
# end
# end
# market_inventory
