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
      max_icons = 6 # Only num1.png through num6.png exist
      trip_days.each_with_index do |trip, i|
        # Cycle through icons if more days than available icons
        icon_num = (i % max_icons) + 1
        icons[trip.id] = ActionController::Base.helpers.asset_path("numbers/num#{icon_num}.png")
      end
      icons[0] = ActionController::Base.helpers.asset_path('numbers/num6.png')
      icons
    end
end
