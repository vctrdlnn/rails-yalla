class InvitesController < ApplicationController

  def create
    @invite = Invite.new(invite_params) # Make a new Invite
    authorize @invite
    @invite.sender_id = current_user.id # set the sender to the current user
    if @invite.save
      InviteMailer.new_user_invite(@invite, new_user_registration_path(:invite_token => @invite.token)).deliver #send the invite data to our mailer to deliver the email
      flash[:notice] = "Invitation was successfully sent"
      redirect_back(fallback_location: properties_trip_path(@invite.trip_id))
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
