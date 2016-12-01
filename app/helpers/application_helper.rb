module ApplicationHelper
    def set_map_hash(activities, trip_hash = {})
      map_hash = []
      trip_hash = set_day_icon(activities.first.trip.trip_days) if trip_hash.nil?
      activities.where.not(lat: nil, lon: nil).each do |activity|

        map_hash << {
          lat: activity.lat,
          lng: activity.lon,
          # infowindow: render_to_string(partial: "/activities/map_box", locals: { activity: activity }),
          label: activity.index.to_s,
          picture: activity.trip_day.nil? ? trip_hash[0] : trip_hash[activity.trip_day.id]
        }
      end
      map_hash
    end

    def set_day_icon(trip_days)
      icons = {}
      trip_days.each_with_index do |trip, i|
        icons[trip.id] = ActionController::Base.helpers.asset_path('numbers/num' + (i + 1).to_s + '.png')
      end
      icons[0] = ActionController::Base.helpers.asset_path('numbers/num6.png')
      return icons
    end
end
