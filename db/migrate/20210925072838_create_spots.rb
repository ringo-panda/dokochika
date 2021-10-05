class CreateSpots < ActiveRecord::Migration[6.1]
  def change
    create_table :spots do |t|
      t.integer :user_id
      t.string :formatted_address
      t.text :name
      t.text :place_id
      t.text :place_photo_reference_id
      t.text :photographing_person_url
      t.string :photographing_person_name
      t.decimal :lat
      t.decimal :lng
      t.timestamps
    end
  end
end
