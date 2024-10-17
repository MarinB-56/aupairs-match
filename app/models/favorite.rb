class Favorite < ApplicationRecord
  belongs_to :favoriting_user, class_name: 'User'
  belongs_to :favorited_user, class_name: 'User'

  validates :favoriting_user, uniqueness: { scope: :favorited_user }
end
