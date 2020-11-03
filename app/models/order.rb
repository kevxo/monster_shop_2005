class Order < ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip, :status
  validates :user_id, presence: true, allow_nil: true

  has_many :item_orders
  has_many :items, through: :item_orders
  belongs_to :user

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def total_quantity
    if self.status == "Cancelled"
       0
    else
      item_orders.sum(:quantity)
    end
  end

  def remove_quantity
    #ASK ALEX
    items.each do |item|
      ordered = ItemOrder.find_by(item_id: item.id)
      amount = item.inventory -= ordered.quantity
      item.update_attributes(inventory: amount)
    end
  end
  #returns quantity to merchant
  def return_quantity
    items.each do |item|
      returned = ItemOrder.find_by(item_id: item.id)
      item.inventory += returned.quantity
      item.save
    end
  end

  def change_status
    if item_orders.where(fulfilled: true).count == item_orders.count
      update_attributes(status: "Packaged")
    end
  end
end
