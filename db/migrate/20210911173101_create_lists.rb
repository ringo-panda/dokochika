class CreateLists < ActiveRecord::Migration[6.1]
  def change
    create_table :lists do |t|
      t.integer :user_id
      t.string :name
      t.boolean :is_allowed_edit

      t.timestamps
    end
  end
end
