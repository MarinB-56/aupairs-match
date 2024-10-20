class CreateConversationUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :conversation_users do |t|
      t.references :conversation, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
