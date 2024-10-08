class User < ApplicationRecord
  has_many :favorites_given, class_name: 'Favorite', foreign_key: :favoriting_user_id
  has_many :favorites_received, class_name: 'Favorite', foreign_key: :favorited_user_id
end
