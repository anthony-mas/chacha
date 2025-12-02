class Event < ApplicationRecord
  # Associations based on schema
  belongs_to :user

  has_many :participations, dependent: :destroy
  has_many :posts, dependent: :destroy

  # Many-to-many relationship with categories
  has_many :category_events, dependent: :destroy
  has_many :categories, through: :category_events
end
