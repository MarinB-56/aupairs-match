class User < ApplicationRecord
  has_many :favorites_given, class_name: 'Favorite', foreign_key: :favoriting_user_id
  has_many :favorites_received, class_name: 'Favorite', foreign_key: :favorited_user_id
  has_many :matches_given, class_name: 'Favorite', foreign_key: :initiated_by_id
  has_many :matches_received, class_name: 'Favorite', foreign_key: :received_by_id
  has_many :languages, through: :user_languages
  has_many :user_languages
end
