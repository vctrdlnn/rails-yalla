class InvitesController < ApplicationController

  def create
    @invite = Invite.new(invite_params) # Make a new Invite
    authorize @invite
    @invite.sender_id = current_user.id # set the sender to the current user

    if @invite.save
      # If user already exists
      if @invite.recipient.nil?
        InviteMailer.new_user_invite(@invite, new_user_registration_url(:invite_token => @invite.token)).deliver #send the invite data to our mailer to deliver the email
        flash[:notice] = "Invitation was successfully sent"
        redirect_back(fallback_location: properties_trip_path(@invite.trip_id))
      else
        InviteMailer.existing_user_invite(@invite).deliver
        #Add the user to the user group
        participant = @invite.recipient.participants.build({trip: @invite.trip})
        if participant.save
          flash[:notice] = "Participant successfully added to the trip"
        else
          flash[:alert] = "Error adding participant to the trip"
        end
        redirect_back(fallback_location: properties_trip_path(@invite.trip_id))
     end
    else
      # oh no, creating an new invitation failed
    end

  end

  private

  def invite_params
    params.require(:invite).permit(
      :email,
      :trip_id
    )
  end
end
