class CreateFavorites < ActiveRecord::Migration[7.1]
  def change
    create_table :favorites do |t|
      t.integer :favoriting_user_id
      t.integer :favorited_user_id

      t.timestamps
    end
    add_foreign_key :favorites, :users, column: :favoriting_user_id
    add_foreign_key :favorites, :users, column: :favorited_user_id
  end
end
