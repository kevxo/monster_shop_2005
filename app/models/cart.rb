class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents
  end

  def add_item(item)
    @contents[item] = 0 if !@contents[item]
    @contents[item] += 1
  end

  def add_quantity(item, quantity = '1')
    integer = quantity.to_i
    @contents[item] = 0 if !@contents[item]
    @contents[item] += integer
  end

  def minus_quantity(item, quantity = '1')
    integer = quantity.to_i
    @contents[item] -= integer
  end

  def total_items
    @contents.values.sum
  end

  def items
    item_quantity = {}
    @contents.each do |item_id,quantity|
      item_quantity[Item.find(item_id)] = quantity
    end
    item_quantity
  end

  def grand_total
    grand_total = 0.0
    @contents.each do |item_id, quantity|
      grand_total += Item.find(item_id).price * quantity
    end
    grand_total
  end

  def subtotal(item)
    item.price * @contents[item.id.to_s]
  end

  def total
    @contents.sum do |item_id,quantity|
      Item.find(item_id).price * quantity
    end
  end

  def discounted_grand_total
    grand_total = 0.0
    @contents.each do |item_id, quantity|
      grand_total += discounted_subtotal_of(item_id) if find_discount(item_id)
      grand_total += subtotal_of(item_id) if !find_discount(item_id)
    end
    grand_total
  end

  def subtotal_of(item_id)
    @contents[item_id.to_s] * Item.find(item_id).price
  end

  def discounted_subtotal_of(item_id)
    @contents[item_id.to_s] * (Item.find(item_id).price * (1 - (find_discount(item_id).to_f / 100)))
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def find_discount(item_id)
    item = Item.find(item_id)
    discounts = item.merchant.discounts.where("item_quantity <= ?", count_of(item_id))
    return discounts.order(percent: :desc).first.percent if !discounts.empty?
  end

  def find_discounted_price(item_id)
    discounted_subtotal_of(item_id) / count_of(item_id)
  end
end
