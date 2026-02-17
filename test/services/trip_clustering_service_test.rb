require "test_helper"

class TripClusteringServiceTest < ActiveSupport::TestCase
  setup do
    Geocoder.configure(lookup: :test)
    Geocoder::Lookup::Test.add_stub("Paris, FR", [
      { "latitude" => 48.8566, "longitude" => 2.3522 }
    ])

    @user = User.create!(
      username: "testuser",
      email: "test@example.com",
      password: "password123"
    )
    @category = MainCategory.create!(title: "Visits", icon: "icon", color: "bg-visites")
  end

  # --- Helper to build trips quickly ---

  def create_trip(num_days:, activities: [])
    trip = Trip.create!(
      title: "Test Trip",
      city: "Paris",
      country: "FR",
      category: "Discovery",
      user: @user,
      lat: 48.8566,
      lon: 2.3522
    )

    num_days.times do |i|
      trip.trip_days.create!(title: "Day #{i + 1}", date: Date.today + i)
    end

    activities.each do |attrs|
      trip.activities.create!(
        title: attrs[:title] || "Activity",
        address: attrs[:address] || "Paris",
        lat: attrs[:lat],
        lon: attrs[:lon],
        main_category: @category,
        user: @user
      )
    end

    trip.reload
  end

  # --- Edge cases ---

  test "returns failure when trip has no days" do
    trip = Trip.create!(
      title: "Empty Trip", city: "Paris", country: "FR",
      category: "Discovery", user: @user
    )
    result = TripClusteringService.new(trip).call
    assert_not result.success?
    assert_match(/no days/, result.message)
  end

  test "returns failure when not enough geolocated activities" do
    trip = create_trip(num_days: 3, activities: [
      { title: "A1", lat: 48.86, lon: 2.35 },
      { title: "A2", lat: 48.87, lon: 2.36 }
    ])
    result = TripClusteringService.new(trip).call
    assert_not result.success?
    assert_match(/at least 3/, result.message)
  end

  test "returns failure when all activities lack coordinates" do
    trip = create_trip(num_days: 2, activities: [
      { title: "A1", lat: nil, lon: nil },
      { title: "A2", lat: nil, lon: nil }
    ])
    result = TripClusteringService.new(trip).call
    assert_not result.success?
  end

  # --- Single day ---

  test "single day optimizes walking order" do
    trip = create_trip(num_days: 1, activities: [
      { title: "North", lat: 48.90, lon: 2.35 },
      { title: "South", lat: 48.82, lon: 2.35 },
      { title: "Mid",   lat: 48.86, lon: 2.35 }
    ])

    result = TripClusteringService.new(trip).call
    assert result.success?

    day = trip.trip_days.first
    assigned = trip.activities.where(trip_day_id: day.id).order(:index)
    assert_equal 3, assigned.count

    # All activities should have sequential indices
    assert_equal [1, 2, 3], assigned.map(&:index)
  end

  # --- Multi-day clustering ---

  test "clusters activities into correct number of days" do
    # Two distinct neighborhoods: Montmartre (north) and Latin Quarter (south)
    trip = create_trip(num_days: 2, activities: [
      { title: "Sacre Coeur",   lat: 48.8867, lon: 2.3431 },
      { title: "Moulin Rouge",  lat: 48.8841, lon: 2.3323 },
      { title: "Place du Tertre", lat: 48.8863, lon: 2.3408 },
      { title: "Pantheon",      lat: 48.8462, lon: 2.3464 },
      { title: "Luxembourg",    lat: 48.8462, lon: 2.3372 },
      { title: "Notre Dame",    lat: 48.8530, lon: 2.3499 }
    ])

    result = TripClusteringService.new(trip).call
    assert result.success?

    trip.trip_days.each do |day|
      day_activities = trip.activities.where(trip_day_id: day.id)
      assert day_activities.count > 0, "Day #{day.title} should have activities"
    end

    # Total activities assigned should match
    total_assigned = trip.activities.where.not(trip_day_id: nil).count
    assert_equal 6, total_assigned
  end

  test "activities within a day are geographically ordered" do
    trip = create_trip(num_days: 1, activities: [
      { title: "Far East",   lat: 48.85, lon: 2.40 },
      { title: "Far West",   lat: 48.85, lon: 2.25 },
      { title: "Mid East",   lat: 48.85, lon: 2.36 },
      { title: "Mid West",   lat: 48.85, lon: 2.30 }
    ])

    result = TripClusteringService.new(trip).call
    assert result.success?

    ordered = trip.activities.where(trip_day_id: trip.trip_days.first.id).order(:index)
    # Check that total route distance is reasonable (not random order)
    # The optimized route should visit nearby activities consecutively
    lons = ordered.map(&:lon)
    # After optimization, should be monotonically increasing or decreasing (a line of points)
    diffs = lons.each_cons(2).map { |a, b| b - a }
    assert(diffs.all? { |d| d >= 0 } || diffs.all? { |d| d <= 0 },
      "Activities along a line should be ordered sequentially, got lons: #{lons}")
  end

  # --- Ungeolocated activities ---

  test "ungeolocated activities are distributed across days" do
    trip = create_trip(num_days: 2, activities: [
      { title: "Geo1", lat: 48.86, lon: 2.35 },
      { title: "Geo2", lat: 48.87, lon: 2.36 },
      { title: "Geo3", lat: 48.80, lon: 2.30 },
      { title: "Geo4", lat: 48.81, lon: 2.31 },
      { title: "NoGeo1", lat: nil, lon: nil },
      { title: "NoGeo2", lat: nil, lon: nil }
    ])

    result = TripClusteringService.new(trip).call
    assert result.success?

    total_assigned = trip.activities.where.not(trip_day_id: nil).count
    assert_equal 6, total_assigned
  end

  # --- Haversine distance ---

  test "haversine distance is accurate" do
    service = TripClusteringService.new(nil)
    # Paris to London is ~344 km
    dist = service.send(:haversine, 48.8566, 2.3522, 51.5074, -0.1278)
    assert_in_delta 344, dist, 5, "Paris-London distance should be ~344 km"
  end

  # --- Works with many activities (performance) ---

  test "handles 20 activities without timeout" do
    activities = 20.times.map do |i|
      { title: "Act#{i}", lat: 48.83 + (i * 0.005), lon: 2.30 + (i * 0.005) }
    end

    trip = create_trip(num_days: 4, activities: activities)

    start_time = Time.now
    result = TripClusteringService.new(trip).call
    elapsed = Time.now - start_time

    assert result.success?
    assert elapsed < 5, "Should complete in under 5 seconds, took #{elapsed}s"

    # All activities assigned
    total_assigned = trip.activities.where.not(trip_day_id: nil).count
    assert_equal 20, total_assigned
  end

  # --- Uses actual trip day count, not hardcoded ---

  test "works with 5 days" do
    activities = 10.times.map do |i|
      { title: "Act#{i}", lat: 48.83 + (i * 0.01), lon: 2.30 + (i * 0.01) }
    end

    trip = create_trip(num_days: 5, activities: activities)
    result = TripClusteringService.new(trip).call
    assert result.success?

    days_with_activities = trip.trip_days.select { |d| trip.activities.where(trip_day_id: d.id).any? }
    assert_equal 5, days_with_activities.count, "All 5 days should have activities"
  end

  test "indices are sequential within each day" do
    activities = 9.times.map do |i|
      { title: "Act#{i}", lat: 48.83 + (i * 0.005), lon: 2.30 + (i * 0.005) }
    end
    trip = create_trip(num_days: 3, activities: activities)

    result = TripClusteringService.new(trip).call
    assert result.success?

    trip.trip_days.each do |day|
      indices = trip.activities.where(trip_day_id: day.id).order(:index).pluck(:index)
      next if indices.empty?
      assert_equal (1..indices.length).to_a, indices,
        "Indices should be sequential starting from 1 for #{day.title}"
    end
  end
end
