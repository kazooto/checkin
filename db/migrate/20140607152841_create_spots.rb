class CreateSpots < ActiveRecord::Migration
  def change
    create_table :spots do |t|
      t.string :name
      t.integer :category_id
      t.string :description
      t.string :address
      t.string :tel
      t.string :url
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
