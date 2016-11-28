# Trip controller - classic CRUD so far
class TripsController < ApplicationController
  include MapsHashConcern
  before_action :set_trip, only: [:show, :edit, :update, :destroy]

  def index
    @trips = Trip.all
  end

  def show
  end

  def new
    @trip = Trip.new
  end

  def edit
    @disable_footer = true
    @activities = @trip.activities
    @trip_days = @trip.trip_days
    @map_hash = set_map_hash(@activities)
  end

  def create
    @trip = Trip.new(trip_params)
    if @trip.save
      redirect_to @trip, notice: 'Trip was successfully created.'
    else
      render :new
    end
  end

  def update
    if @trip.update(trip_params)
      redirect_to @trip, notice: 'Trip was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @trip.destroy
    redirect_to trips_url, notice: 'Trip was successfully destroyed.'
  end

  private

  def set_trip
    @trip = Trip.find(params[:id])
  end

  def trip_params
    params.require(:trip).permit(
      :title, :description, :category,
      :city, :country, :lat, :lon,
      :photo, :photo_cache, :public, :user_id
    )
  end
end
