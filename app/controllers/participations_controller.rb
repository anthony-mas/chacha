class ParticipationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:create, :update, :destroy]

  def create
    @participation = @event.participations.new(participation_params.merge(user: current_user))

    if @participation.save
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def update
    @participation = @event.participations.find_by!(user: current_user)

    if @participation.update(participation_params)
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def destroy
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
    params.fetch(:participation, {}).permit(:status, :guest_approval, :role)
  end
end
