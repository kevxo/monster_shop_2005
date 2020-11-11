class AddTimestampsToDiscounts < ActiveRecord::Migration[5.2]
  def change
    add_column :discounts, :created_at, :datetime, null: false
    add_column :discounts, :updated_at, :datetime, null: false
  end
end
