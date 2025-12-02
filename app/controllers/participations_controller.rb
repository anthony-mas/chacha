class ParticipationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:create, :destroy]

  # POST /events/:event_id/participations
  def create
    # Status default to 'going' for RSVP, role defaults to standard participant
    @participation = @event.participations.new(participation_params.merge(user: current_user))

    if @participation.save
      head :ok
    else
      # Using Turbo streams/Hotwire, status: :unprocessable_entity is common for errors
      head :unprocessable_entity
    end
  end

  # DELETE /events/:event_id/participations/:id (or we can find by user/event pair)
  def destroy
    # Assuming we are deleting the current user's participation for the event
    @participation = @event.participations.find_by!(user: current_user)

    if @participation.destroy
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def participation_params
    # Allowing status, guest_approval, and role to be passed in, as per schema
    params.fetch(:participation, {}).permit(:status, :guest_approval, :role)
  end
end
