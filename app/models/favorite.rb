class Favorite < ApplicationRecord
  belongs_to :favoriting_user, class_name: 'User', foreign_key: 'favoriting_user_id'
  belongs_to :favorited_user, class_name: 'User', foreign_key: 'favorited_user_id'
end
