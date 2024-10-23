class Match < ApplicationRecord
  belongs_to :initiated_by, class_name: 'User'
  belongs_to :received_by, class_name: 'User'

  enum status: { pending: 'pending', accepted: 'accepted', refused: 'refused' }
  validates :initiated_by, uniqueness: { scope: :received_by }

  def other_user(user)
    user == initiated_by ? received_by : initiated_by
  end
end
