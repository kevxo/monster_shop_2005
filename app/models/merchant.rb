class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :item_orders, through: :items
  has_many :users, -> { where role: :merchant }

  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip


  def no_orders?
    item_orders.empty?
  end

  def item_count
    items.count
  end

  def average_item_price
    items.average(:price)
  end

  def distinct_cities
    item_orders.distinct.joins(:order).pluck(:city)
  end

  def total_quantity
    item_orders.sum(:quantity)
  end

  def total_value
    item_orders.sum(:price)
  end

  def orders_id
    item_orders.pluck(:order_id).first
  end

  def order_creation
    item_orders.pluck(:created_at).first
  end

  def merchant_disabled
    self.status = "Disabled"
  end

  def deactivate_items
    self.items.update(activation_status: 'Deactivated')
  end

  def merchant_enabled
    self.status = "Enabled"
  end
end
