class EventsController < ApplicationController
  # Only logged-in users can create / edit / delete
  before_action :authenticate_user!, except: [:show]
  before_action :set_event, only: [:show, :edit, :update, :destroy]

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

  # Adapt to your schema: location, title, description, starts_on, ends_on, event_private
  def event_params
    params.require(:event).permit(
      :location,
      :title,
      :description,
      :starts_on,
      :ends_on,
      :event_private
    )
  end
end
