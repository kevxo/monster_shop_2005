class RemoveFillStatusFromItems < ActiveRecord::Migration[5.2]
  def change
    remove_column :items, :fill_status, :string
  end
end
