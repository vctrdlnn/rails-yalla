trip_hash = set_day_icon(@trip.trip_days)
json.array! @trip.activities.order(:trip_day_id, :index) do |act|
  json.extract! act, :lat
  json.lng act.lon
  json.label act.index.to_s
  json.picture act.trip_day.nil? ? trip_hash[0] : trip_hash[act.trip_day.id]
  json.infowindow raw render '/activities/map_box.html', activity: act
end
