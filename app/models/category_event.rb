class CategoryEvent < ApplicationRecord
  # Associations based on schema
  belongs_to :event
  belongs_to :category
end
