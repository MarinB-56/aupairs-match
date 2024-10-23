class User < ApplicationRecord
  validates :first_name, :birth_date, :gender, presence: true, if: -> { aupair? }
  validates :number_of_children, presence: true, if: -> { family? }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :favorites_given, class_name: 'Favorite', foreign_key: :favoriting_user_id, dependent: :destroy
  has_many :favorites_received, class_name: 'Favorite', foreign_key: :favorited_user_id, dependent: :destroy

  has_many :matches_given, class_name: 'Match', foreign_key: :initiated_by_id, dependent: :destroy
  has_many :matches_received, class_name: 'Match', foreign_key: :received_by_id, dependent: :destroy

  has_many :user_languages, dependent: :destroy
  has_many :languages, through: :user_languages
  has_many :availabilities, dependent: :destroy
  accepts_nested_attributes_for :availabilities, allow_destroy: true
  accepts_nested_attributes_for :user_languages, allow_destroy: true

  # Pour la messagerie
  has_many :conversation_users
  has_many :conversations, through: :conversation_users
  has_many :messages

  enum role: { aupair: 0, family: 1 }
  has_one_attached :photo

  # Geocoding
  # Geocoder va chercher l'adresse dans "location" pour trouver lat et lng
  geocoded_by :location
  # Après l'enregistrement dans la base de donnée, si locaiton a changé, maj des lat et lng
  after_validation :geocode, if: :will_save_change_to_location?

  def conversation_with(other_user)
    Conversation.joins(:conversation_users)
                .where(conversation_users: { user_id: [id, other_user.id] })
                .group('conversations.id')
                .having('COUNT(DISTINCT conversation_users.user_id) = 2')
                .first
  end
end
