class RemoveIndexFromUsers < ActiveRecord::Migration
  def change
    remove_index :users, [:uid, :provider]
  end
end
