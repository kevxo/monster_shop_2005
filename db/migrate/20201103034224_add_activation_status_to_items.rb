class AddActivationStatusToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :activation_status, :string, :default => 'Activated'
    #Ex:- :default =>''
  end
end
