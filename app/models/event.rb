class Event < ApplicationRecord
  attr_accessor :hero_image_choice
  has_one_attached :hero_image

  belongs_to :user
  has_many :participations, dependent: :destroy
  has_many :participants, through: :participations, source: :user
  has_many :posts, dependent: :destroy

  has_many :category_events, dependent: :destroy
  has_many :categories, through: :category_events

  # ===========================
  # SCOPES
  # ===========================

  # Events for "My Events" page: hosted by user OR user is going/maybe
  # Note: We use subquery for participating IDs to avoid structural mismatch with .or()
  scope :for_user, ->(user) {
    participating_event_ids = Participation
      .where(user_id: user.id, status: %w[going maybe])
      .select(:event_id)

    where(user_id: user.id)
      .or(where(id: participating_event_ids))
      .distinct
  }

  scope :most_popular, -> {
    joins(:participations)
      .group("events.id")
      .order("COUNT(participations.id) DESC")
  }

  scope :by_location, ->(location) {
    where("LOWER(location) LIKE ?", "%#{location.downcase}%") if location.present?
  }

  scope :by_category_name, ->(category_name) {
    joins(:categories)
      .where(categories: { name: category_name })
      .distinct
  }

  def self.attended_by_friends(current_user)
    return none unless current_user&.respond_to?(:friends) && current_user.friends.present?

    friend_ids = current_user.friends.pluck(:id)
    joins(:participations)
      .where(participations: { user_id: friend_ids })
      .distinct
  end

  # ===========================
  # DISCOVER FILTER LOGIC
  # ===========================

  def self.discover_filter(params, current_user)
    events = Event.where(event_private: false)

    if params[:filter] == "top"
      events = events.most_popular

    elsif params[:filter] == "friends"
      events = events.attended_by_friends(current_user)

    elsif params[:filter].present? && params[:filter] != params[:location]
      events = events.by_category_name(params[:filter])
    end

    events = events.by_location(params[:location]) if params[:location].present?

    events = events.order(starts_on: :asc) unless params[:filter] == "top"

    events
  end

  # ===========================
  # HELPERS
  # ===========================

  def display_time_and_location
    time = starts_on.strftime("%-I%P").downcase
    date_prefix = (starts_on.to_date == Date.current ? "Today" : starts_on.strftime("%A"))
    "#{date_prefix} #{time} - #{location.upcase}"
  end
end
