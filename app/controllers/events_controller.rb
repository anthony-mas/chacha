class EventsController < ApplicationController
  # Allow non-logged-in users to see the show page, discover, and the calendar download
  before_action :authenticate_user!, except: [:show, :discover, :calendar]
  before_action :set_event, only: [:show, :edit, :update, :destroy, :calendar]
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

  # ADDED: Action to export event as iCalendar (.ics) file
  def calendar
    respond_to do |format|
      format.ics do
        # Set headers to download a file named after the event title
        headers['Content-Type'] = 'text/calendar; charset=UTF-8'
        headers['Content-Disposition'] = "attachment; filename=\"#{@event.title.parameterize}.ics\""
        render 'events/calendar', formats: [:ics] # Render the template at app/views/events/calendar.ics.erb
      end
      # Fallback for non-ics requests
      format.html { redirect_to @event }
    end
  end

  def new
    @event = Event.new
  end

  def create
    @event = current_user.events.build(event_params)

    if @event.save
      attach_hero_image_from_choice(@event)
      redirect_to @event, notice: "Event created successfully 🎉"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      attach_hero_image_from_choice(@event)
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
      :hero_image,
      :hero_image_choice,
      category_ids: []
    )
  end

  def attach_hero_image_from_choice(event)
    choice = params.dig(:event, :hero_image_choice)
    return if choice.blank?

    # Images are stored in public/hero_library/ (no fingerprinting issues)
    path = Rails.root.join("public/hero_library", choice)
    return unless File.exist?(path)

    event.hero_image.purge if event.hero_image.attached?
    event.hero_image.attach(
      io: File.open(path),
      filename: choice,
      content_type: Marcel::MimeType.for(name: choice)
    )
  end
end
