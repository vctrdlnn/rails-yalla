module ActivitiesHelper
  GOOGLE_TYPE_LABELS = {
    'restaurant' => 'Restaurant',
    'cafe' => 'Café',
    'bar' => 'Bar',
    'night_club' => 'Night Club',
    'museum' => 'Museum',
    'art_gallery' => 'Art Gallery',
    'church' => 'Church',
    'hindu_temple' => 'Temple',
    'mosque' => 'Mosque',
    'synagogue' => 'Synagogue',
    'park' => 'Park',
    'zoo' => 'Zoo',
    'aquarium' => 'Aquarium',
    'amusement_park' => 'Amusement Park',
    'stadium' => 'Stadium',
    'gym' => 'Gym',
    'spa' => 'Spa',
    'hotel' => 'Hotel',
    'lodging' => 'Lodging',
    'airport' => 'Airport',
    'train_station' => 'Train Station',
    'bus_station' => 'Bus Station',
    'subway_station' => 'Metro Station',
    'shopping_mall' => 'Shopping Mall',
    'store' => 'Store',
    'bakery' => 'Bakery',
    'library' => 'Library',
    'movie_theater' => 'Cinema',
    'tourist_attraction' => 'Attraction',
    'point_of_interest' => 'Point of Interest',
    'establishment' => 'Establishment'
  }.freeze

  def humanize_place_type(google_category)
    return 'Place' if google_category.blank?
    GOOGLE_TYPE_LABELS[google_category] || google_category.titleize.gsub('_', ' ')
  end

  def activity_photo_index_path(activity)
    if activity.photo_url.nil?
      cl_image_path("city2_glimf7.jpg", width: 200, height: 150, crop: :fill)
    else
      cl_image_path(activity.photo.url(:summary))
    end
  end

  def activity_photo_index_tag(activity)
    if activity.photo_url.nil?
      cl_image_tag("city2_glimf7.jpg", width: 200, height: 150, crop: :fill)
    else
      cl_image_tag(activity.photo.url(:summary))
    end
  end
end
