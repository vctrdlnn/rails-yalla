class RegistrationsController < Devise::RegistrationsController
  include PendingTripCreation

  def new
    @token = params[:invite_token]
    super
  end

  def create
    super do
      @token = params["user"]["invite_token"]
      if @token != nil
        trip_joined =  Invite.find_by_token(@token).trip #find the user group attached to the invite
        participant = resource.participants.build({trip: trip_joined, role: "Editor"}) #add this user to the new user group as a member
        if participant.save
          flash[:notice] = "You have been successfully added to the trip"
        else
          flash[:alert] = "Error adding you to the trip"
        end
      end
    end
  end

  def after_sign_up_path_for(resource)
    if session[:pending_trip].present?
      trip = create_pending_trip_for_user(resource)
      return edit_trip_path(trip) if trip
    end
    my_trips_path
  end

  private

  def after_update_path_for(resource)
    edit_user_registration_path
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def account_update_params
    params.require(:user).permit(:username, :phone, :hometown, :photo, :photo_cache)
  end
end
