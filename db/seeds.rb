# =============================================================================
# YALA SEEDS - Production-ready seed file
# =============================================================================
#
# Usage:
#   1. Create db/seeds_data.json with your trips and activities
#   2. Run: rails db:seed (local) or scalingo run rails db:seed (production)
#
# =============================================================================

require 'json'

# -----------------------------------------------------------------------------
# STEP 1: Clean up existing data (in correct order for foreign keys)
# -----------------------------------------------------------------------------
puts "Cleaning up existing data..."

PinnedActivity.destroy_all
Activity.destroy_all
TripDay.destroy_all
Participant.destroy_all
Invite.destroy_all
Trip.destroy_all
Category.destroy_all
MainCategory.destroy_all
# Only destroy non-admin users in development
User.where(admin: false).destroy_all if Rails.env.development?

puts "Cleanup complete"

# -----------------------------------------------------------------------------
# STEP 2: Load seed data from JSON
# -----------------------------------------------------------------------------
seeds_file = Rails.root.join('db', 'seeds_data.json')
seed_data = File.exist?(seeds_file) ? JSON.parse(File.read(seeds_file), symbolize_names: true) : {}

# -----------------------------------------------------------------------------
# STEP 3: Create or update admin user (skip welcome email)
# -----------------------------------------------------------------------------
puts "Creating admin user..."

admin_params = seed_data[:admin_user] || {
  username: "yala_admin",
  email: "admin@yala-app.fr",
  password: "change_me_in_production",
  phone: "0600000000"
}

# Override with environment variables if set (for production security)
admin_params[:email] = ENV['ADMIN_EMAIL'] if ENV['ADMIN_EMAIL'].present?
admin_params[:password] = ENV['ADMIN_PASSWORD'] if ENV['ADMIN_PASSWORD'].present?

# Skip welcome email callback for seeding
User.skip_callback(:create, :after, :send_welcome_email) rescue nil

admin = User.find_or_initialize_by(email: admin_params[:email])
admin.assign_attributes(
  username: admin_params[:username],
  password: admin_params[:password],
  phone: admin_params[:phone],
  first_name: admin_params[:first_name],
  last_name: admin_params[:last_name],
  admin: true
)
admin.save!

# Re-enable callback
User.set_callback(:create, :after, :send_welcome_email) rescue nil

puts "Admin user created: #{admin.email}"

# -----------------------------------------------------------------------------
# STEP 4: Create Main Categories
# -----------------------------------------------------------------------------
puts "Creating main categories..."

main_categories =
[
  {
    title: "Cultural",
    icon: "categories/cultural.png",
    color: "bg-visites"
  },
  {
    title: "Visits",
    icon: "categories/visits.png",
    color: "bg-visites"
  },
  {
    title: "Restaurants",
    icon: "categories/restaurants.png",
    color: "bg-food"
  },
  {
    title: "Bar & Nightlife",
    icon: "categories/bar & nightlife.png",
    color: "bg-food"
  },
  {
    title: "Shopping",
    icon: "categories/shopping.png",
    color: "bg-shopping"
  },
  {
    title: "Nature",
    icon: "categories/nature.png",
    color: "bg-nature"
  },
  {
    title: "Outdoor",
    icon: "categories/outdoor.png",
    color: "bg-nature"
  },
  {
    title: "Sport",
    icon: "categories/sport.png",
    color: "bg-fun"
  },
  {
    title: "Hotels",
    icon: "categories/hotels.png",
    color: "bg-others"
  },
  {
    title: "Kids",
    icon: "categories/kids.png",
    color: "bg-fun"
  },
  {
    title: "Transportation",
    icon: "categories/transportation.png",
    color: "bg-others"
  },
  {
    title: "Fun",
    icon: "categories/fun.png",
    color: "bg-fun"
  },
  {
    title: "Others",
    icon: "categories/others.png",
    color: "bg-others"
  }
  # {
  #   title: "Communication",
  #   icon: "categories/communication.png",
  #   color: "bg-others"
  # },
  # {
  #   title: "Best of City",
  #   icon: "categories/Best of City.png",
  #   color: "bg-visites"
  # },
]

main_categories.each do |mn|
  MainCategory.create!(mn)
end

puts "#{MainCategory.count} main categories created"

# -----------------------------------------------------------------------------
# STEP 5: Create Categories (Google Places mapping)
# -----------------------------------------------------------------------------
puts "Creating categories..."

categories =
[
{ main_category_id: MainCategory.find_by(title:"Restaurants").id, google_title: "cafe", title: "Cafe"},
{ main_category_id: MainCategory.find_by(title:"Restaurants").id, google_title: "bakery", title: "Bakery"},
{ main_category_id: MainCategory.find_by(title:"Restaurants").id, google_title: "grocery_or_supermarket(deprecated)", title: "Grocery Or Supermarket"},
{ main_category_id: MainCategory.find_by(title:"Restaurants").id, google_title: "food (deprecated)", title: "Food "},
{ main_category_id: MainCategory.find_by(title:"Restaurants").id, google_title: "meal_delivery", title: "Meal Delivery"},
{ main_category_id: MainCategory.find_by(title:"Restaurants").id, google_title: "meal_takeaway", title: "Meal Takeaway"},
{ main_category_id: MainCategory.find_by(title:"Restaurants").id, google_title: "restaurant", title: "Restaurant"},
{ main_category_id: MainCategory.find_by(title:"Bar & Nightlife").id, google_title: "bar", title: "Bar"},
{ main_category_id: MainCategory.find_by(title:"Bar & Nightlife").id, google_title: "night_club", title: "Night Club"},
{ main_category_id: MainCategory.find_by(title:"Nature").id, google_title: "aquarium", title: "Aquarium"},
{ main_category_id: MainCategory.find_by(title:"Nature").id, google_title: "amusement_park", title: "Amusement Park"},
{ main_category_id: MainCategory.find_by(title:"Nature").id, google_title: "florist", title: "Florist"},
{ main_category_id: MainCategory.find_by(title:"Nature").id, google_title: "rv_park", title: "Rv Park"},
{ main_category_id: MainCategory.find_by(title:"Nature").id, google_title: "zoo", title: "Zoo"},
{ main_category_id: MainCategory.find_by(title:"Nature").id, google_title: "park", title: "Park"},
{ main_category_id: MainCategory.find_by(title:"Nature").id, google_title: "pet_store", title: "Pet Store"},
{ main_category_id: MainCategory.find_by(title:"Nature").id, google_title: "veterinary_care", title: "Veterinary Care"},
{ main_category_id: MainCategory.find_by(title:"Transportation").id, google_title: "airport", title: "Airport"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "bank", title: "Bank"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "car_dealer", title: "Car Dealer"},
{ main_category_id: MainCategory.find_by(title:"Transportation").id, google_title: "car_rental", title: "Car Rental"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "car_repair", title: "Car Repair"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "car_wash", title: "Car Wash"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "dentist", title: "Dentist"},
{ main_category_id: MainCategory.find_by(title:"Shopping").id, google_title: "department_store", title: "Department Store"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "doctor", title: "Doctor"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "electrician", title: "Electrician"},
{ main_category_id: MainCategory.find_by(title:"Shopping").id, google_title: "electronics_store", title: "Electronics Store"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "embassy", title: "Embassy"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "accounting", title: "Accounting"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "atm", title: "Atm"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "plumber", title: "Plumber"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "police", title: "Police"},
{ main_category_id: MainCategory.find_by(title:"Transportation").id, google_title: "gas_station", title: "Gas Station"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "general_contractor (deprecated)", title: "General Contractor "},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "finance (deprecated)", title: "Finance "},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "fire_station", title: "Fire Station"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "hospital", title: "Hospital"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "insurance_agency", title: "Insurance Agency"},
{ main_category_id: MainCategory.find_by(title:"Shopping").id, google_title: "jewelry_store", title: "Jewelry Store"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "laundry", title: "Laundry"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "lawyer", title: "Lawyer"},
{ main_category_id: MainCategory.find_by(title:"Shopping").id, google_title: "library", title: "Library"},
{ main_category_id: MainCategory.find_by(title:"Shopping").id, google_title: "liquor_store", title: "Liquor Store"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "local_government_office", title: "Local Government Office"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "locksmith", title: "Locksmith"},
{ main_category_id: MainCategory.find_by(title:"Hotels").id, google_title: "lodging", title: "Lodging"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "cemetery", title: "Cemetery"},
{ main_category_id: MainCategory.find_by(title:"Cultural").id, google_title: "church", title: "Church"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "city_hall", title: "City Hall"},
{ main_category_id: MainCategory.find_by(title:"Shopping").id, google_title: "clothing_store", title: "Clothing Store"},
{ main_category_id: MainCategory.find_by(title:"Shopping").id, google_title: "convenience_store", title: "Convenience Store"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "courthouse", title: "Courthouse"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "establishment (deprecated)", title: "Establishment "},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "beauty_salon", title: "Beauty Salon"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "hair_care", title: "Hair Care"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "hardware_store", title: "Hardware Store"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "health (deprecated)", title: "Health "},
{ main_category_id: MainCategory.find_by(title:"Cultural").id, google_title: "hindu_temple", title: "Hindu Temple"},
{ main_category_id: MainCategory.find_by(title:"Shopping").id, google_title: "home_goods_store", title: "Home Goods Store"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "book_store", title: "Book Store"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "bus_station", title: "Bus Station"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "funeral_home", title: "Funeral Home"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "furniture_store", title: "Furniture Store"},
{ main_category_id: MainCategory.find_by(title:"Cultural").id, google_title: "mosque", title: "Mosque"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "moving_company", title: "Moving Company"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "painter", title: "Painter"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "pharmacy", title: "Pharmacy"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "physiotherapist", title: "Physiotherapist"},
{ main_category_id: MainCategory.find_by(title:"Cultural").id, google_title: "place_of_worship (deprecated)", title: "Place Of Worship "},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "post_office", title: "Post Office"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "real_estate_agency", title: "Real Estate Agency"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "roofing_contractor", title: "Roofing Contractor"},
{ main_category_id: MainCategory.find_by(title:"Transportation").id, google_title: "parking", title: "Parking"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "school", title: "School"},
{ main_category_id: MainCategory.find_by(title:"Shopping").id, google_title: "shoe_store", title: "Shoe Store"},
{ main_category_id: MainCategory.find_by(title:"Shopping").id, google_title: "shopping_mall", title: "Shopping Mall"},
{ main_category_id: MainCategory.find_by(title:"Sport").id, google_title: "stadium", title: "Stadium"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "storage", title: "Storage"},
{ main_category_id: MainCategory.find_by(title:"Shopping").id, google_title: "store", title: "Store"},
{ main_category_id: MainCategory.find_by(title:"Transportation").id, google_title: "subway_station", title: "Subway Station"},
{ main_category_id: MainCategory.find_by(title:"Cultural").id, google_title: "synagogue", title: "Synagogue"},
{ main_category_id: MainCategory.find_by(title:"Transportation").id, google_title: "taxi_stand", title: "Taxi Stand"},
{ main_category_id: MainCategory.find_by(title:"Transportation").id, google_title: "train_station", title: "Train Station"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "transit_station", title: "Transit Station"},
{ main_category_id: MainCategory.find_by(title:"Transportation").id, google_title: "travel_agency", title: "Travel Agency"},
{ main_category_id: MainCategory.find_by(title:"Others").id, google_title: "university", title: "University"},
{ main_category_id: MainCategory.find_by(title:"Fun").id, google_title: "casino", title: "Casino"},
{ main_category_id: MainCategory.find_by(title:"Fun").id, google_title: "bowling_alley", title: "Bowling Alley"},
{ main_category_id: MainCategory.find_by(title:"Fun").id, google_title: "campground", title: "Campground"},
{ main_category_id: MainCategory.find_by(title:"Fun").id, google_title: "spa", title: "Spa"},
{ main_category_id: MainCategory.find_by(title:"Fun").id, google_title: "movie_rental", title: "Movie Rental"},
{ main_category_id: MainCategory.find_by(title:"Fun").id, google_title: "movie_theater", title: "Movie Theater"},
{ main_category_id: MainCategory.find_by(title:"Cultural").id, google_title: "art_gallery", title: "Art Gallery"},
{ main_category_id: MainCategory.find_by(title:"Cultural").id, google_title: "museum", title: "Museum"},
{ main_category_id: MainCategory.find_by(title:"Sport").id, google_title: "bicycle_store", title: "Bicycle Store"},
{ main_category_id: MainCategory.find_by(title:"Sport").id, google_title: "gym", title: "Gym"}
]

categories.each do |c|
  Category.create!(c)
end

puts "#{Category.count} categories created"

# -----------------------------------------------------------------------------
# STEP 6: Create Trips from JSON (or use defaults)
# -----------------------------------------------------------------------------
puts "Creating trips..."

# Helper to safely load remote photos (skip in production to avoid Cloudinary issues)
def safe_remote_photo(record, url)
  return if url.blank?
  return if Rails.env.production? # Skip photo uploads in production seeds
  begin
    record.remote_photo_url = url
    record.save
  rescue => e
    puts "  Warning: Could not load photo from #{url}: #{e.message}"
  end
end

# Helper to fetch Unsplash photo for a city
def fetch_unsplash_photo(city)
  require 'net/http'
  access_key = ENV['UNSPLASH_ACCESS_KEY']
  return nil if access_key.blank? || access_key == 'YOUR_UNSPLASH_ACCESS_KEY_HERE'

  uri = URI("https://api.unsplash.com/search/photos")
  uri.query = URI.encode_www_form(
    query: "#{city} city travel",
    per_page: 1,
    orientation: 'landscape'
  )

  request = Net::HTTP::Get.new(uri)
  request['Authorization'] = "Client-ID #{access_key}"

  response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
    http.request(request)
  end

  if response.is_a?(Net::HTTPSuccess)
    data = JSON.parse(response.body)
    data['results'].first&.dig('urls', 'regular')
  end
rescue StandardError => e
  puts "  Warning: Could not fetch Unsplash photo for #{city}: #{e.message}"
  nil
end

# Get trips from JSON or use empty array
json_trips = seed_data[:trips] || []

if json_trips.any?
  # Load trips from JSON file
  json_trips.each_with_index do |trip_data, index|
    puts "  Creating trip #{index + 1}/#{json_trips.count}: #{trip_data[:title]} (#{trip_data[:city]})"

    # Create the trip
    trip = Trip.create!(
      title: trip_data[:title],
      description: trip_data[:description],
      category: trip_data[:category],
      city: trip_data[:city],
      country: trip_data[:country],
      user: admin,
      lat: trip_data[:lat],
      lon: trip_data[:lon],
      public: true
    )

    # Load trip photo - try JSON first, then fetch from Unsplash
    photo_url = trip_data[:photo_url]
    if photo_url.blank? && ENV['UNSPLASH_ACCESS_KEY'].present?
      puts "    Fetching photo from Unsplash for #{trip_data[:city]}..."
      photo_url = fetch_unsplash_photo(trip_data[:city])
      sleep 1.2 if photo_url # Rate limiting for Unsplash API
    end
    safe_remote_photo(trip, photo_url)

    # Create trip days
    trip_days = trip_data[:trip_days] || ["Day 1", "Day 2", "Day 3"]
    created_days = []
    trip_days.each do |day_title|
      day = trip.trip_days.create!(title: day_title)
      created_days << day
    end

    # Create activities
    activities = trip_data[:activities] || []
    activities.each_with_index do |act_data, act_index|
      # Find the main category
      main_cat = MainCategory.find_by(title: act_data[:main_category]) || MainCategory.first

      # Determine which trip day (if any)
      trip_day = nil
      if act_data[:trip_day_index].present? && created_days[act_data[:trip_day_index]]
        trip_day = created_days[act_data[:trip_day_index]]
      end

      activity = Activity.create!(
        title: act_data[:title],
        description: act_data[:description],
        main_category: main_cat,
        establishment: act_data[:establishment],
        address: act_data[:address],
        city: trip_data[:city],
        lat: act_data[:lat],
        lon: act_data[:lon],
        url: act_data[:url],
        google_place_identifier: act_data[:google_place_identifier],
        index: act_index + 1,
        trip: trip,
        trip_day: trip_day,
        user: admin  # Required field!
      )

      # Load activity photo
      safe_remote_photo(activity, act_data[:photo_url])
    end

    puts "    -> #{activities.count} activities created"
  end
else
  # Fallback: create sample trips if no JSON provided
  puts "  No JSON data found, creating sample trips..."

  sample_trips = [
    { title: "Week-end à Paris", description: "Découvrez la Rive Gauche parisienne", category: "Discovery", city: "Paris", country: "France" },
    { title: "Amsterdam Explorer", description: "Canals, museums and gezelligheid", category: "Friends", city: "Amsterdam", country: "Netherlands" },
    { title: "Roma Eterna", description: "Art, history and the best pasta", category: "Cultural", city: "Rome", country: "Italy" }
  ]

  sample_trips.each do |t|
    trip = Trip.create!(t.merge(user: admin))
    ["Day 1", "Day 2", "Day 3"].each { |d| trip.trip_days.create!(title: d) }

    # Create a sample activity
    Activity.create!(
      title: "Explore the city center",
      description: "Start your trip with a walking tour",
      main_category: MainCategory.find_by(title: "Visits") || MainCategory.first,
      establishment: "City Center",
      address: "#{t[:city]} City Center, #{t[:country]}",
      city: t[:city],
      trip: trip,
      user: admin
    )
  end
end

puts "Seeding complete!"
puts "=" * 50
puts "Summary:"
puts "  - Admin: #{admin.email}"
puts "  - Trips: #{Trip.count}"
puts "  - Activities: #{Activity.count}"
puts "  - Main Categories: #{MainCategory.count}"
puts "=" * 50

