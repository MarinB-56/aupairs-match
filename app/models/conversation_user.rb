class ConversationUser < ApplicationRecord
  belongs_to :conversation
  belongs_to :user
end
