class Category < ApplicationRecord
  # Associations based on schema
  # Many-to-many relationship with events
  has_many :category_events, dependent: :destroy
  has_many :events, through: :category_events
end
