module GuestTripAccess
  extend ActiveSupport::Concern

  private

  def guest_trip_access?(trip)
    trip.claim_token.present? &&
      session[:claim_token].present? &&
      session[:claim_token] == trip.claim_token
  end

  def authenticate_user_or_guest!
    return if user_signed_in?

    trip = find_trip_for_guest_check
    return if trip && guest_trip_access?(trip)

    authenticate_user!
  end

  def authorize_or_skip_for_guest!(record, query = nil)
    if user_signed_in?
      authorize record, query
    elsif guest_trip_access?(record.is_a?(Trip) ? record : record.trip)
      skip_authorization
    else
      raise Pundit::NotAuthorizedError
    end
  end

  def find_trip_for_guest_check
    if params[:id] && controller_name == "trips"
      Trip.find_by(id: params[:id])
    elsif params[:trip_id]
      Trip.find_by(id: params[:trip_id])
    elsif params[:activity] && params[:activity][:trip_id]
      Trip.find_by(id: params[:activity][:trip_id])
    elsif params[:id] && controller_name == "activities"
      Activity.find_by(id: params[:id])&.trip
    end
  end
end
