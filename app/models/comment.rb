class Comment < ApplicationRecord
  # Associations based on schema
  belongs_to :user
  belongs_to :post
end
