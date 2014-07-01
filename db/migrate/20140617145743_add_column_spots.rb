class AddColumnSpots < ActiveRecord::Migration
  def change
    add_column :spots, :user_id, :integer
    add_index :spots, :user_id
  end
end
