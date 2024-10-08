class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.date :birth_date
      t.text :description
      t.string :nationality
      t.string :gender
      t.string :location
      t.integer :number_of_children
      t.string :role

      t.timestamps
    end
  end
end
