namespace :trips do
  desc "Update trip photos from seeds_data.json (uploads to Cloudinary)"
  task update_photos: :environment do
    require 'json'

    seeds_path = Rails.root.join('db', 'seeds_data.json')
    unless File.exist?(seeds_path)
      puts "ERROR: seeds_data.json not found"
      exit 1
    end

    seeds_data = JSON.parse(File.read(seeds_path), symbolize_names: true)

    puts "Updating trip photos from seeds_data.json..."
    puts "Found #{seeds_data[:trips].count} trips in JSON"

    # Temporarily disable geocoding callback
    Trip.skip_callback(:validation, :after, :geocode)

    updated = 0
    skipped = 0
    failed = 0

    seeds_data[:trips].each_with_index do |trip_data, idx|
      photo_url = trip_data[:photo_url]

      if photo_url.blank?
        puts "  [#{idx + 1}] #{trip_data[:city]} - No photo URL in JSON, skipping"
        skipped += 1
        next
      end

      trip = Trip.find_by(city: trip_data[:city], title: trip_data[:title])

      if trip.nil?
        puts "  [#{idx + 1}] #{trip_data[:city]} - Trip not found, skipping"
        skipped += 1
        next
      end

      if trip.photo.present?
        puts "  [#{idx + 1}] #{trip_data[:city]} - Already has photo, skipping"
        skipped += 1
        next
      end

      begin
        puts "  [#{idx + 1}] #{trip_data[:city]} - Uploading photo..."
        trip.remote_photo_url = photo_url
        trip.save!
        puts "    -> Success!"
        updated += 1
      rescue => e
        puts "    -> Error: #{e.message}"
        failed += 1
      end
    end

    # Re-enable geocoding callback
    Trip.set_callback(:validation, :after, :geocode)

    puts "\n" + "=" * 50
    puts "Photo update complete!"
    puts "  Updated: #{updated}"
    puts "  Skipped: #{skipped}"
    puts "  Failed: #{failed}"
    puts "=" * 50
  end

  desc "List trips missing photos"
  task missing_photos: :environment do
    trips_without_photos = Trip.where(photo: [nil, ''])
    puts "Trips missing photos: #{trips_without_photos.count}"
    trips_without_photos.each do |trip|
      puts "  - #{trip.id}: #{trip.title} (#{trip.city})"
    end
  end
end
