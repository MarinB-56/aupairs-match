class Availability < ApplicationRecord
  belongs_to :user

  validates :start, :end, presence: true
end
