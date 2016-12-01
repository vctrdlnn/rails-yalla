json.extract! @trip, :id, :title, :city
json.activities @trip.activities do |activity|
  json.extract! activity, :id, :title, :address
end
