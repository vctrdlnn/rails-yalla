class Api::V1::TripsController < Api::V1::BaseController
  before_action :set_trip, only: [ :show ]

  def index
    @trips = policy_scope(Trip)
  end

  def show
  end

  private

  def set_trip
    @trip = Trip.find(params[:id])
    authorize @trip  # For Pundit
  end
end
