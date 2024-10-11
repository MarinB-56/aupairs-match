class User < ApplicationRecord
  validates :first_name, :birth_date, :gender, presence: true, if: -> { aupair? }
  validates :number_of_children, presence: true, if: -> { family? }
  has_many :favorites_given, class_name: 'Favorite', foreign_key: :favoriting_user, dependent: :destroy
  has_many :favorites_received, class_name: 'Favorite', foreign_key: :favorited_user, dependent: :destroy
  has_many :matches_given, class_name: 'Favorite', foreign_key: :initiated_by, dependent: :destroy
  has_many :matches_received, class_name: 'Favorite', foreign_key: :received_by, dependent: :destroy
  has_many :availabilities, dependent: :destroy
  has_many :languages, through: :user_languages
  has_many :user_languages, dependent: :destroy
  enum role: { aupair: 0, family: 1 }
  has_one_attached :photo
end
