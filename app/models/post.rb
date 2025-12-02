class Post < ApplicationRecord
  # Associations based on schema
  belongs_to :user
  belongs_to :event

  has_many :comments, dependent: :destroy
  has_many :reactions, dependent: :destroy
end
