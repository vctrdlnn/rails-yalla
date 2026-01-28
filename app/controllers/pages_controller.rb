class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :unsplash_photo]
  skip_after_action :verify_authorized

  def home
    @trips = policy_scope(Trip)
    @trips = @trips.sort { |x, y| y.likes <=> x.likes }
    @trips = @trips.first(4)
  end

  def unsplash_photo
    query = params[:query]&.downcase&.strip
    index = params[:index].to_i # Which photo to return (0-9)
    return render json: { error: 'Query required' }, status: :bad_request if query.blank?

    access_key = ENV['UNSPLASH_ACCESS_KEY']
    if access_key.blank? || access_key == 'YOUR_UNSPLASH_ACCESS_KEY_HERE'
      return render json: { error: 'Unsplash API key not configured' }, status: :service_unavailable
    end

    # Cache results for 24 hours to reduce API calls
    cache_key = "unsplash_photos_#{query.parameterize}"
    cached_photos = Rails.cache.read(cache_key)

    unless cached_photos
      Rails.logger.info "[Unsplash] Fetching photos for '#{query}'"

      require 'net/http'
      require 'json'

      uri = URI("https://api.unsplash.com/search/photos")
      uri.query = URI.encode_www_form(
        query: "#{query} city travel",
        per_page: 10,
        orientation: 'landscape'
      )

      request = Net::HTTP::Get.new(uri)
      request['Authorization'] = "Client-ID #{access_key}"

      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(request)
      end

      if response.is_a?(Net::HTTPSuccess)
        data = JSON.parse(response.body)
        if data['results'].any?
          cached_photos = data['results'].map do |photo|
            {
              url: photo['urls']['regular'],
              thumb: photo['urls']['thumb'],
              photographer: photo['user']['name'],
              photographer_url: photo['user']['links']['html']
            }
          end
          # Cache for 24 hours
          Rails.cache.write(cache_key, cached_photos, expires_in: 24.hours)
        else
          return render json: { error: 'No photos found' }, status: :not_found
        end
      else
        return render json: { error: 'Unsplash API error' }, status: :bad_gateway
      end
    else
      Rails.logger.info "[Unsplash] Cache hit for '#{query}'"
    end

    # Return the requested photo (cycle through if index exceeds count)
    photo_index = index % cached_photos.length
    result = cached_photos[photo_index].merge(total: cached_photos.length)
    render json: result
  rescue StandardError => e
    Rails.logger.error "[Unsplash] Error: #{e.message}"
    render json: { error: 'Failed to fetch photo' }, status: :internal_server_error
  end
end
