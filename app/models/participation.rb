class Participation < ApplicationRecord
  # Associations based on schema
  belongs_to :event
  belongs_to :user
end
