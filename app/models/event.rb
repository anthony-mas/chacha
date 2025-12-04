class Event < ApplicationRecord
  attr_accessor :hero_image_choice
  has_one_attached :hero_image

  # Core Associations
  belongs_to :user
  has_many :participations, dependent: :destroy
  has_many :participants, through: :participations, source: :user
  has_many :posts, dependent: :destroy

  # Many-to-many relationship with categories
  has_many :category_events, dependent: :destroy
  has_many :categories, through: :category_events

  # Association for 'Interested' (Save) functionality using Reactions
  # NOTE: Requires a polymorphic `Reaction` model reacting to `Event`
  has_many :reactions, as: :reactable, dependent: :destroy
  has_many :savers, -> { where(reactions: { reaction_type: 'save' }) },
           through: :reactions, source: :user

  # --- NEW SCOPES FOR DISCOVER PAGE FILTERING ---

  # 1. Scope for 'Top' (Popularity): Orders by number of participants
  scope :most_popular, -> {
    joins(:participations)
      .group('events.id')
      .order('COUNT(participations.id) DESC')
  }

  # 2. Scope for 'Location'
  scope :by_location, ->(location) { where("location ILIKE ?", "%#{location.downcase}%") if location.present? }

  # 3. Scope for 'Category'
  scope :by_category_name, ->(category_name) {
    joins(:categories)
      .where(categories: { name: category_name })
      .distinct
  }

  # 4. Class method for 'Friends' Attendance
  # NOTE: Requires the current_user to have a `friends` method defined (e.g., in the User model).
  def self.attended_by_friends(current_user)
    return none unless current_user&.respond_to?(:friends) && current_user.friends.present?

    friend_ids = current_user.friends.pluck(:id)
    joins(:participations).where(participations: { user_id: friend_ids }).distinct
  end

  # Class method to apply all filters for the discover page
  def self.discover_filter(params, current_user)
    # Start with all public events (assuming event_private: false means public)
    events = Event.where(event_private: false)

    if params[:filter] == 'top'
      events = events.most_popular
    elsif params[:filter] == 'friends'
      events = events.attended_by_friends(current_user)
    elsif params[:category].present?
      events = events.by_category_name(params[:category])
    end

    # Location filter (applied consistently)
    events = events.by_location(params[:location]) if params[:location].present?

    # Fallback order if no specific filter is applied
    events = events.order(starts_on: :asc) unless params[:filter] == 'top'

    events
  end

  # --- HELPER METHODS FOR THE VIEW ---

  # Checks if the current user has "saved" the event
  def saved_by?(user)
    savers.include?(user)
  end

  # Helper method for displaying the time and location: "Today 10pm - PARIS"
  def display_time_and_location
    time = starts_on.strftime('%-I%P').downcase
    date_prefix = starts_on.to_date == Date.current ? 'Today' : starts_on.strftime('%A')
    "#{date_prefix} #{time} - #{location.upcase}"
  end
end
