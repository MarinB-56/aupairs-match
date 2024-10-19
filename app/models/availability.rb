class Availability < ApplicationRecord
  belongs_to :user

  validates :start_date, :end_date, presence: true
end
