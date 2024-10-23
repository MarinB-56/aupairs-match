class Conversation < ApplicationRecord
  has_many :conversation_users, dependent: :destroy
  has_many :users, through: :conversation_users
  has_many :messages, dependent: :destroy
end
