class CreateMatches < ActiveRecord::Migration[7.1]
  def change
    create_table :matches do |t|
      t.string :status
      t.references :initiated_by, foreign_key: { to_table: :users }
      t.references :received_by, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
