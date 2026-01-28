require 'csv'
require 'json'
require 'net/http'

namespace :seeds do
  desc "Generate seeds_data.json from CSV files"
  task generate_json: :environment do
    puts "Generating seeds_data.json from CSV files..."

    # Category mapping from CSV categories to valid Trip categories
    CATEGORY_MAP = {
      "Cultural" => "Cultural",
      "Historical" => "Cultural",
      "Visits" => "Discovery",
      "Fun" => "Friends",
      "Heritage" => "Cultural",
      "Bar & Nightlife" => "Friends",
      "Shopping" => "Discovery",
      "Restaurants" => "Discovery",
      "Mixed" => "Discovery",
      "Nature" => "Discovery"
    }.freeze

    # Main category mapping for activities
    MAIN_CATEGORY_MAP = {
      "Attraction" => "Fun",
      "Museum" => "Cultural",
      "Hotel" => "Hotels",
      "Restaurants" => "Restaurants",
      "Visits" => "Visits",
      "Activity" => "Fun",
      "Bar" => "Bar & Nightlife",
      "Nightlife" => "Bar & Nightlife",
      "Pub" => "Bar & Nightlife",
      "Cafe" => "Restaurants",
      "Bakery" => "Restaurants",
      "Wine Bar" => "Bar & Nightlife",
      "Cocktails" => "Bar & Nightlife",
      "Experience" => "Fun",
      "Shopping" => "Shopping"
    }.freeze

    # Parse coordinates from various formats
    def parse_coordinates(coord_string)
      return [nil, nil] if coord_string.blank?

      # Handle formats like "41.41379 N, 2.16431 E" or "45.5032° N, 73.5562° W"
      coord_string = coord_string.gsub('°', '').strip

      if coord_string =~ /(\d+\.?\d*)\s*([NS]),?\s*(\d+\.?\d*)\s*([EW])/i
        lat = $1.to_f
        lat = -lat if $2.upcase == 'S'
        lon = $3.to_f
        lon = -lon if $4.upcase == 'W'
        [lat, lon]
      elsif coord_string =~ /(-?\d+\.?\d*),?\s*(-?\d+\.?\d*)/
        [$1.to_f, $2.to_f]
      else
        [nil, nil]
      end
    end

    # Clean google_place_id (remove AI formulas and invalid entries)
    def clean_google_place_id(place_id)
      return nil if place_id.blank?
      return nil if place_id.include?('=AI(')
      return nil if place_id.include?('Generating')
      return nil if place_id.include?('not supported')
      return nil if place_id.length < 10

      # Some entries have multiple IDs or garbage, take the first valid one
      place_id = place_id.split("\n").first&.strip
      place_id = place_id.split(',').first&.strip if place_id

      place_id.presence
    end

    # Load trips CSV (note: has empty first row and Windows line endings)
    trips_csv_path = Rails.root.join('db', 'SEEDS - trips.csv')
    trips_data = []

    # Read the file, clean up Windows line endings, skip empty first row
    csv_content = File.read(trips_csv_path, encoding: 'UTF-8')
    csv_content = csv_content.gsub("\r\n", "\n").gsub("\r", "\n")

    # Skip the first empty row
    lines = csv_content.lines
    lines.shift if lines.first&.strip&.match?(/^,+$/) || lines.first&.strip&.empty?
    csv_content = lines.join

    CSV.parse(csv_content, headers: true, skip_blanks: true) do |row|
      next if row['title'].blank?

      trips_data << {
        title: row['title']&.strip,
        description: row['description']&.strip,
        original_category: row['category']&.strip,
        category: CATEGORY_MAP[row['category']&.strip] || 'Discovery',
        city: row['city']&.strip,
        country: row['country']&.strip,
        lat: row['lat']&.to_f,
        lon: row['lon']&.to_f,
        trip_days_str: row['trip_days']&.strip,
        activities_str: row['activities']&.strip
      }
    end

    puts "Found #{trips_data.count} trips in CSV"

    # Load activities CSV (note: Windows line endings)
    activities_csv_path = Rails.root.join('db', 'SEEDS - activities.csv')
    activities_by_city = Hash.new { |h, k| h[k] = [] }

    # Read and clean up Windows line endings
    activities_content = File.read(activities_csv_path, encoding: 'UTF-8')
    activities_content = activities_content.gsub("\r\n", "\n").gsub("\r", "\n")

    CSV.parse(activities_content, headers: true, skip_blanks: true) do |row|
      city = row['City']&.strip
      next if city.blank?

      lat, lon = parse_coordinates(row['Coordinates'])

      activity = {
        id: row['ID'],
        city: city,
        country: row['Country'],
        category: row['Remapped Category'],
        main_category: MAIN_CATEGORY_MAP[row['Remapped Category']] || 'Visits',
        title: row['Title - value']&.strip,
        establishment: row['Establishment']&.strip,
        description: row['Description']&.strip,
        address: row['Address']&.strip,
        lat: lat,
        lon: lon,
        google_place_identifier: clean_google_place_id(row['Google_place_id'])
      }

      # Skip invalid activities
      next if activity[:title].blank? && activity[:establishment].blank?

      # Use establishment as title if title is weird or missing
      if activity[:title].blank? ||
         activity[:title].length < 3 ||
         activity[:title].include?('Generating') ||
         activity[:title].include?('Missing')
        activity[:title] = activity[:establishment]
      end

      activities_by_city[city] << activity
    end

    puts "Found activities for #{activities_by_city.keys.count} cities"

    # Build the final JSON structure
    json_trips = []

    trips_data.each do |trip|
      city = trip[:city]
      city_activities = activities_by_city[city] || []

      # Parse trip days
      trip_days = if trip[:trip_days_str].present?
        trip[:trip_days_str].split(',').map(&:strip)
      else
        ['Day 1', 'Day 2', 'Day 3']
      end

      # Distribute activities across days
      activities_per_day = (city_activities.count.to_f / trip_days.count).ceil
      activities_per_day = [activities_per_day, 5].min # Max 5 per day

      activities_json = []
      city_activities.each_with_index do |act, idx|
        # Determine which day (cycle through days)
        day_index = if trip_days.count > 1
          idx % trip_days.count
        else
          0
        end

        # Hotels don't need a specific day
        day_index = nil if act[:main_category] == 'Hotels'

        activities_json << {
          title: act[:title] || act[:establishment],
          description: act[:description],
          main_category: act[:main_category],
          establishment: act[:establishment],
          address: act[:address] || "#{city}, #{trip[:country]}",
          lat: act[:lat],
          lon: act[:lon],
          google_place_identifier: act[:google_place_identifier],
          url: nil,
          photo_url: nil,
          trip_day_index: day_index
        }
      end

      json_trips << {
        title: trip[:title],
        description: trip[:description],
        category: trip[:category],
        city: trip[:city],
        country: trip[:country],
        lat: trip[:lat],
        lon: trip[:lon],
        photo_url: nil,  # Will be fetched via Unsplash during seeding
        trip_days: trip_days,
        activities: activities_json
      }
    end

    # Build final JSON
    seeds_json = {
      admin_user: {
        username: "yala_admin",
        email: "admin@yala-app.fr",
        password: "change_me_in_production",
        phone: "0600000000",
        first_name: "Yala",
        last_name: "Admin"
      },
      trips: json_trips
    }

    # Write to file
    output_path = Rails.root.join('db', 'seeds_data.json')
    File.write(output_path, JSON.pretty_generate(seeds_json))

    puts "Generated #{output_path}"
    puts "Total trips: #{json_trips.count}"
    puts "Total activities: #{json_trips.sum { |t| t[:activities].count }}"

    # Print summary per city
    puts "\nActivities per city:"
    json_trips.each do |trip|
      puts "  #{trip[:city]}: #{trip[:activities].count} activities"
    end
  end

  desc "Fetch Unsplash photos for trips in seeds_data.json"
  task fetch_photos: :environment do
    require 'net/http'
    require 'json'

    access_key = ENV['UNSPLASH_ACCESS_KEY']
    if access_key.blank? || access_key == 'YOUR_UNSPLASH_ACCESS_KEY_HERE'
      puts "ERROR: UNSPLASH_ACCESS_KEY not configured"
      puts "Set it in your .env file or environment"
      exit 1
    end

    seeds_path = Rails.root.join('db', 'seeds_data.json')
    unless File.exist?(seeds_path)
      puts "ERROR: seeds_data.json not found. Run rake seeds:generate_json first"
      exit 1
    end

    seeds_data = JSON.parse(File.read(seeds_path))

    puts "Fetching Unsplash photos for #{seeds_data['trips'].count} trips..."

    seeds_data['trips'].each_with_index do |trip, idx|
      next if trip['photo_url'].present?

      city = trip['city']
      puts "  [#{idx + 1}/#{seeds_data['trips'].count}] Fetching photo for #{city}..."

      uri = URI("https://api.unsplash.com/search/photos")
      uri.query = URI.encode_www_form(
        query: "#{city} city travel",
        per_page: 1,
        orientation: 'landscape'
      )

      request = Net::HTTP::Get.new(uri)
      request['Authorization'] = "Client-ID #{access_key}"

      begin
        response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
          http.request(request)
        end

        if response.is_a?(Net::HTTPSuccess)
          data = JSON.parse(response.body)
          if data['results'].any?
            photo = data['results'].first
            trip['photo_url'] = photo['urls']['regular']
            trip['photo_thumb'] = photo['urls']['thumb']
            trip['photographer'] = photo['user']['name']
            trip['photographer_url'] = photo['user']['links']['html']
            puts "    -> Found: #{trip['photo_url'][0..60]}..."
          else
            puts "    -> No photos found"
          end
        else
          puts "    -> API error: #{response.code}"
        end
      rescue StandardError => e
        puts "    -> Error: #{e.message}"
      end

      # Rate limiting - Unsplash allows 50 requests/hour for demo apps
      sleep 1.5
    end

    # Write updated JSON
    File.write(seeds_path, JSON.pretty_generate(seeds_data))
    puts "\nUpdated #{seeds_path} with photo URLs"
  end
end
