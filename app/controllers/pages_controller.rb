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
    return render json: { error: 'Query required' }, status: :bad_request if query.blank?

    access_key = ENV['UNSPLASH_ACCESS_KEY']
    if access_key.blank? || access_key == 'YOUR_UNSPLASH_ACCESS_KEY_HERE'
      return render json: { error: 'Unsplash API key not configured' }, status: :service_unavailable
    end

    # Cache results for 24 hours to reduce API calls
    cache_key = "unsplash_photo_#{query.parameterize}"
    cached_result = Rails.cache.read(cache_key)

    if cached_result
      Rails.logger.info "[Unsplash] Cache hit for '#{query}'"
      return render json: cached_result
    end

    Rails.logger.info "[Unsplash] Fetching photo for '#{query}'"

    require 'net/http'
    require 'json'

    uri = URI("https://api.unsplash.com/search/photos")
    uri.query = URI.encode_www_form(
      query: "#{query} city travel",
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
      if data['results'].any?
        photo = data['results'].first
        result = {
          url: photo['urls']['regular'],
          thumb: photo['urls']['thumb'],
          photographer: photo['user']['name'],
          photographer_url: photo['user']['links']['html']
        }
        # Cache for 24 hours
        Rails.cache.write(cache_key, result, expires_in: 24.hours)
        render json: result
      else
        render json: { error: 'No photos found' }, status: :not_found
      end
    else
      render json: { error: 'Unsplash API error' }, status: :bad_gateway
    end
  rescue StandardError => e
    Rails.logger.error "[Unsplash] Error: #{e.message}"
    render json: { error: 'Failed to fetch photo' }, status: :internal_server_error
  end
end
