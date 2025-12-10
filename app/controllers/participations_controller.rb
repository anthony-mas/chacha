class ParticipationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:create, :update, :destroy, :update_guest_status]
  before_action :authorize_host!, only: [:update_guest_status]

  def create
    @participation = @event.participations.find_by(user: current_user)

    # Update user's name and mobile if provided in the form
    update_user_info_if_provided

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

    # Update user's name and mobile if provided in the form
    update_user_info_if_provided

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

  # Host-only action to change any guest's status
  def update_guest_status
    @participation = @event.participations.find(params[:id])

    if @participation.update(participation_params)
      respond_to_participation_change
    else
      head :unprocessable_entity
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def authorize_host!
    unless @event.user == current_user
      head :forbidden
    end
  end

  def participation_params
    params.fetch(:participation, {}).permit(:status, :guest_approval, :role, :extra_guests)
  end

  def update_user_info_if_provided
    user_params = params.fetch(:user, {}).permit(:name, :mobile_number)
    updates = user_params.to_h.select { |_, v| v.present? }
    current_user.update(updates) if updates.any?
  end

  def respond_to_participation_change
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("guests-list", partial: "events/guests_list", locals: { event: @event }),
          turbo_stream.replace("rsvp-segmented-control", partial: "shared/rsvp_segmented_control", locals: {
            current_status: @participation&.persisted? ? @participation.status : nil,
            context: "page"
          }),
          turbo_stream.replace("manage-guests-content", partial: "events/manage_guests_content", locals: { event: @event }),
          turbo_stream.replace("rsvp-modal-content", partial: "events/rsvp_modal_content")
        ]
      end
      format.html { redirect_to @event }
      format.json { head :ok }
    end
  end
end
