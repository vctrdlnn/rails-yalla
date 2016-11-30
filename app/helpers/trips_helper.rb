module TripsHelper

  def panel_id(tripday)
    tripday.title.downcase.gsub(' ', '_')
  end

  def trip_type_class(trip)
    if trip.user == current_user
      "personal_trips"
    else
      "liked_trips"
    end
  end
end
