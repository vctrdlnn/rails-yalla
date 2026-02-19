class CleanupUnclaimedTripsJob < ApplicationJob
  queue_as :default

  def perform
    trips = Trip.expired_unclaimed
    count = trips.count
    trips.destroy_all
    Rails.logger.info "CleanupUnclaimedTripsJob: Deleted #{count} unclaimed trips older than 30 days"
  end
end
