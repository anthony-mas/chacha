class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations based on schema
  # KEEP: User is the host of the event.
  has_many :events, dependent: :destroy
  # KEEP: User participates in events.
  has_many :participations, dependent: :destroy

  # REMOVED: Direct access to user activity is restricted.
  # has_many :posts, dependent: :destroy
  # has_many :comments, dependent: :destroy
  # has_many :reactions, dependent: :destroy
end
