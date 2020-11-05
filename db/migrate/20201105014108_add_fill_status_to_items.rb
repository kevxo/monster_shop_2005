class AddFillStatusToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :fill_status, :string, default: "Unfulfilled"
  end
end
