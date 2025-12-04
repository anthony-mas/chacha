class EventsController < ApplicationController
  # Allow non-logged-in users to see the show page and the new discover page
  before_action :authenticate_user!, except: [:show, :discover]
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :set_categories, only: [:new, :edit]

  # --- NEW ACTION ---
  def discover
    # Determine default or current location for filtering
    location = params[:location].presence || current_user.try(:city) || 'Paris'

    # The categories available for filters
    @categories = ['Social', 'Sport', 'Art & Culture', 'Networking', 'Hobbies']

    # Fetch and filter events using the new model method
    @events = Event.discover_filter(
      params.merge(location: location),
      current_user
    )

    # Pass the applied filters for styling the active tags
    @current_location = location
    @current_filter = params[:filter].presence || params[:category].presence
  end

  # Host dashboard – list only current_user's events
  def index
    if user_signed_in?
      @events = current_user.events
    else
      @events = Event.none
    end
  end

  # Public event page (host + guests see this)
  def show
  end

  def new
    @event = Event.new
  end

  def create
    @event = current_user.events.build(event_params)

    if @event.save
      redirect_to @event, notice: "Event created successfully 🎉"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: "Event updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path, notice: "Event deleted."
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def set_categories
    @categories = Category.all.order(:name)
  end

  def event_params
    params.require(:event).permit(
      :location,
      :title,
      :description,
      :starts_on,
      :ends_on,
      :event_private,
      category_ids: []
    )
  end
end
