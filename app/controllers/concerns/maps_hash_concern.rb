# app/models/concerns/test_concern.rb
# app/controllers/concerns/test_concern.rb

module MapsHashConcern
  extend ActiveSupport::Concern

  included do
      # Ici nous allons mettre nos scopes, relations et paramètres de configuration de celles-ci.
      # ex: has_namy, belongs_to ...
      # ex: validates Rails ou perso
      # ex: default_scope { where(approved: true)}
      # ex: MIN_QUANTITY = 1
    def set_map_hash(activities, trip_hash = {})
      map_hash = []
      trip_hash = set_day_icon(activities.first.trip.trip_days) if trip_hash.nil?
      activities.where.not(lat: nil, lon: nil).each do |activity|

        map_hash << {
          lat: activity.lat,
          lng: activity.lon,
          infowindow: render_to_string(partial: "/activities/map_box", locals: { activity: activity }),
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
  module ClassMethods
      # Ici nous allons mettre toutes les méthodes de classe et d'instances pouvant être mutualisées.
      # Les méthodes déclarées dans ce module deviennent des méthodes de classe sur la classe cible ( où l'on inclus notre concern ).



    private
      # les méthodes privées ne pouvant être appelées qu'à l'intérieur de ce concern.
  end
end
