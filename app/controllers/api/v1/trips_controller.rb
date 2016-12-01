class Api::V1::TripsController < Api::V1::BaseController
  def index
    @trips = policy_scope(Trip)
  end
end
