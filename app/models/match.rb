class Match < ApplicationRecord
  belongs_to :initiated_by, class_name: 'User'
  belongs_to :received_by, class_name: 'User'
end
