class CreateAvailabilities < ActiveRecord::Migration[7.1]
  def change
    create_table :availabilities do |t|
      t.date :start
      t.date :end
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
