class ParticipationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:create, :update, :destroy]

  def create
    @participation = @event.participations.find_by(user: current_user)

    # Update user's name if provided in the form
    update_user_name_if_provided

    if @participation
      # Update existing participation
      if @participation.update(participation_params)
        respond_to_participation_change
      else
        head :unprocessable_entity
      end
    else
      # Create new participation
      @participation = @event.participations.new(participation_params.merge(user: current_user))
      if @participation.save
        respond_to_participation_change
      else
        head :unprocessable_entity
      end
    end
  end

  def update
    @participation = @event.participations.find_by!(user: current_user)

    if @participation.update(participation_params)
      respond_to_participation_change
    else
      head :unprocessable_entity
    end
  end

  def destroy
    @participation = @event.participations.find_by!(user: current_user)

    if @participation.destroy
      respond_to_participation_change
    else
      head :unprocessable_entity
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def participation_params
    params.fetch(:participation, {}).permit(:status, :guest_approval, :role, :extra_guests)
  end

  def update_user_name_if_provided
    user_name = params.dig(:user, :name)
    if user_name.present?
      current_user.update(name: user_name)
    end
  end

  def respond_to_participation_change
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("guests-list", partial: "events/guests_list", locals: { event: @event }),
          turbo_stream.replace("rsvp-segmented-control", partial: "shared/rsvp_segmented_control", locals: {
            current_status: @participation&.persisted? ? @participation.status : nil,
            context: "page"
          })
        ]
      end
      format.html { redirect_to @event }
      format.json { head :ok }
    end
  end
end
