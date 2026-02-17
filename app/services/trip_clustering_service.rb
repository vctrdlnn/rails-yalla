class TripClusteringService
  Result = Struct.new(:success?, :message, keyword_init: true)

  EARTH_RADIUS_KM = 6371.0
  MIN_POINTS_FOR_DBSCAN = 2

  def initialize(trip)
    @trip = trip
  end

  def call
    days = @trip.trip_days.order(:created_at).to_a
    return Result.new("success?": false, message: "This trip has no days.") if days.empty?

    activities = @trip.activities.to_a
    geolocated = activities.select { |a| a.lat.present? && a.lon.present? }
    ungeolocated = activities - geolocated

    if geolocated.length < days.length
      return Result.new(
        "success?": false,
        message: "Need at least #{days.length} geolocated activities (currently #{geolocated.length})."
      )
    end

    if days.length == 1
      ordered = optimize_route(geolocated)
      assign_activities(ordered + ungeolocated, [days.first])
    else
      clusters = cluster_into_days(geolocated, days.length)
      clusters.each { |c| c.replace(optimize_route(c)) }
      distribute_ungeolocated(ungeolocated, clusters)
      assign_activities_from_clusters(clusters, days)
    end

    Result.new("success?": true, message: "Your itinerary has been optimized!")
  end

  private

  # --- Haversine distance in km ---

  def haversine(lat1, lon1, lat2, lon2)
    dlat = to_rad(lat2 - lat1)
    dlon = to_rad(lon2 - lon1)
    a = Math.sin(dlat / 2)**2 +
        Math.cos(to_rad(lat1)) * Math.cos(to_rad(lat2)) * Math.sin(dlon / 2)**2
    EARTH_RADIUS_KM * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
  end

  def to_rad(deg)
    deg * Math::PI / 180.0
  end

  def activity_distance(a, b)
    haversine(a.lat, a.lon, b.lat, b.lon)
  end

  # --- DBSCAN clustering ---

  def cluster_into_days(activities, num_days)
    return [activities.dup] if num_days == 1

    clusters = dbscan(activities, auto_eps(activities))
    noise = clusters.delete(:noise) || []

    # Assign noise points to nearest cluster
    if clusters.any?
      noise.each { |act| nearest_cluster(act, clusters) << act }
    else
      # All noise — treat each activity as its own cluster
      clusters = activities.map { |a| [object_id, [a]] }.to_h
      clusters = Hash[activities.each_with_index.map { |a, i| [i, [a]] }]
    end

    cluster_list = clusters.values

    # Balance to match day count
    cluster_list = merge_clusters(cluster_list, num_days) while cluster_list.length > num_days
    cluster_list = split_clusters(cluster_list, num_days) while cluster_list.length < num_days

    cluster_list
  end

  def auto_eps(activities)
    return 1.0 if activities.length < MIN_POINTS_FOR_DBSCAN

    distances = []
    activities.each_with_index do |a, i|
      ((i + 1)...activities.length).each do |j|
        distances << activity_distance(a, activities[j])
      end
    end
    distances.sort!

    # 20th percentile of pairwise distances
    idx = [(distances.length * 0.2).floor, 0].max
    [distances[idx] || 1.0, 0.5].max
  end

  def dbscan(activities, eps, min_pts = 2)
    visited = {}
    clusters = {}
    cluster_id = 0

    activities.each do |act|
      next if visited[act.id]
      visited[act.id] = true

      neighbors = region_query(act, activities, eps)

      if neighbors.length < min_pts
        clusters[:noise] ||= []
        clusters[:noise] << act
      else
        cluster_id += 1
        clusters[cluster_id] = [act]
        expand_cluster(act, neighbors, clusters, cluster_id, visited, activities, eps, min_pts)
      end
    end

    clusters
  end

  def region_query(act, activities, eps)
    activities.select { |other| other.id != act.id && activity_distance(act, other) <= eps }
  end

  def expand_cluster(point, neighbors, clusters, cluster_id, visited, activities, eps, min_pts)
    queue = neighbors.dup
    while queue.any?
      current = queue.shift
      unless visited[current.id]
        visited[current.id] = true
        new_neighbors = region_query(current, activities, eps)
        queue.concat(new_neighbors) if new_neighbors.length >= min_pts
      end

      # Add to cluster if not already in one
      already_clustered = clusters.any? { |k, v| k != :noise && v.include?(current) }
      unless already_clustered
        clusters[:noise]&.delete(current)
        clusters[cluster_id] << current
      end
    end
  end

  def nearest_cluster(activity, clusters)
    clusters.values.min_by do |cluster|
      centroid = cluster_centroid(cluster)
      haversine(activity.lat, activity.lon, centroid[:lat], centroid[:lon])
    end
  end

  def cluster_centroid(cluster)
    {
      lat: cluster.sum(&:lat) / cluster.length.to_f,
      lon: cluster.sum(&:lon) / cluster.length.to_f
    }
  end

  # --- Merge / Split to match day count ---

  def merge_clusters(clusters, target)
    return clusters if clusters.length <= target

    # Find two closest clusters by centroid distance and merge them
    min_dist = Float::INFINITY
    merge_i = 0
    merge_j = 1

    clusters.each_with_index do |c1, i|
      ((i + 1)...clusters.length).each do |j|
        c2 = clusters[j]
        cent1 = cluster_centroid(c1)
        cent2 = cluster_centroid(c2)
        dist = haversine(cent1[:lat], cent1[:lon], cent2[:lat], cent2[:lon])
        if dist < min_dist
          min_dist = dist
          merge_i = i
          merge_j = j
        end
      end
    end

    merged = clusters[merge_i] + clusters[merge_j]
    result = clusters.dup
    result.delete_at(merge_j)
    result[merge_i] = merged
    result
  end

  def split_clusters(clusters, target)
    return clusters if clusters.length >= target

    # Split the largest cluster along its widest geographic axis
    largest_idx = clusters.each_with_index.max_by { |c, _| c.length }[1]
    cluster = clusters[largest_idx]

    lat_range = cluster.max_by(&:lat).lat - cluster.min_by(&:lat).lat
    lon_range = cluster.max_by(&:lon).lon - cluster.min_by(&:lon).lon

    sorted = if lat_range >= lon_range
               cluster.sort_by(&:lat)
             else
               cluster.sort_by(&:lon)
             end

    mid = sorted.length / 2
    part1 = sorted[0...mid]
    part2 = sorted[mid..]

    result = clusters.dup
    result.delete_at(largest_idx)
    result.push(part1, part2)
    result
  end

  # --- Nearest-neighbor TSP + 2-opt ---

  def optimize_route(activities)
    return activities if activities.length <= 2

    # Nearest-neighbor heuristic
    route = [activities.first]
    remaining = activities[1..].dup

    while remaining.any?
      nearest = remaining.min_by { |a| activity_distance(route.last, a) }
      route << nearest
      remaining.delete(nearest)
    end

    # 2-opt improvement
    two_opt(route)
  end

  def two_opt(route)
    return route if route.length <= 3

    improved = true
    while improved
      improved = false
      (1...(route.length - 1)).each do |i|
        ((i + 1)...route.length).each do |j|
          old_dist = segment_distance(route, i, j)
          new_dist = swap_distance(route, i, j)
          if new_dist < old_dist
            route[i..j] = route[i..j].reverse
            improved = true
          end
        end
      end
    end

    route
  end

  def segment_distance(route, i, j)
    activity_distance(route[i - 1], route[i]) +
      (j + 1 < route.length ? activity_distance(route[j], route[j + 1]) : 0)
  end

  def swap_distance(route, i, j)
    activity_distance(route[i - 1], route[j]) +
      (j + 1 < route.length ? activity_distance(route[i], route[j + 1]) : 0)
  end

  # --- Distribute ungeolocated activities ---

  def distribute_ungeolocated(ungeolocated, clusters)
    return if ungeolocated.empty?

    ungeolocated.each_with_index do |act, i|
      clusters[i % clusters.length] << act
    end
  end

  # --- Persist assignments ---

  def assign_activities(ordered, days)
    ActiveRecord::Base.transaction do
      per_day = (ordered.length.to_f / days.length).ceil
      ordered.each_slice(per_day).with_index do |group, day_idx|
        day = days[[day_idx, days.length - 1].min]
        group.each_with_index do |activity, pos|
          activity.update!(trip_day_id: day.id, index: pos + 1)
        end
      end
    end
  end

  def assign_activities_from_clusters(clusters, days)
    ActiveRecord::Base.transaction do
      clusters.each_with_index do |cluster, day_idx|
        day = days[day_idx]
        cluster.each_with_index do |activity, pos|
          activity.update!(trip_day_id: day.id, index: pos + 1)
        end
      end
    end
  end
end
