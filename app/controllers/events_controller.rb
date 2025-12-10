class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :discover, :calendar]
  before_action :set_event, only: [:show, :edit, :update, :destroy, :calendar]
  before_action :set_categories, only: [:new, :edit]

  # --- DISCOVER ACTION ---
  def discover
    location = params[:filter].presence || current_user.try(:city) || "Paris"

    @categories = [
      "Social", "Sport", "Art & Culture", "Networking", "Hobbies"
    ]

    # Pass all filtering to Event model
    @events = Event.discover_filter(params, current_user)

    @current_location = location
    @current_filter   = params[:filter]
    
  end

  def index
    @events = user_signed_in? ? current_user.events : Event.none
  end

  def show; end

  def calendar
    respond_to do |format|
      format.ics do
        headers["Content-Type"] = "text/calendar; charset=UTF-8"
        headers["Content-Disposition"] =
          "attachment; filename=\"#{@event.title.parameterize}.ics\""

        render "events/calendar", formats: [:ics]
      end
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

  def edit; end

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

  # Static hero image selection
  def attach_hero_image_from_choice(event)
    choice = params.dig(:event, :hero_image_choice)
    return if choice.blank?

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
