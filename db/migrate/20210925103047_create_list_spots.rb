class CreateListSpots < ActiveRecord::Migration[6.1]
  def change
    create_table :list_spots do |t|
      t.integer :user_id
      t.integer :list_id
      t.integer :spot_id

      t.timestamps
    end
  end
end
