class CreateFavorites < ActiveRecord::Migration[7.1]
  def change
    create_table :favorites do |t|
      t.references :favoriting_user, foreign_key: { to_table: :users }
      t.references :favorited_user, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
