class Category < ApplicationRecord
  # Associations based on schema
  has_many :category_events, dependent: :destroy
  has_many :events, through: :category_events

  validates :name, presence: true # New line to add
end
