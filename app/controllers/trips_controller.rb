class TripsController < ApplicationController
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
  end

  def create
    @trip = Trip.new(trip_params)
      if @trip.save
        redirect_to @trip, notice: 'Trip was successfully created.'
      else
        render :new
      end
    end
  end

  def update
    respond_to do |format|
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

  def search
    fail
  end

  private
    def set_trip
      @trip = Trip.find(params[:id])
    end

    def trip_params
      params.require(:trip).permit(:title, :description, :category,
        :city, :country, :lat, :lon, :photo, :photo_cache, :public, :user_id)
    end
end
end
