json.array! @trips do |trip|
  json.extract! trip, :id, :title, :city
end
