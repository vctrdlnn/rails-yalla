# Trip controller - classic CRUD so far
class TripsController < ApplicationController
  include MapsHashConcern
  skip_before_action :authenticate_user!, only: [:index, :show ]
  before_action :set_trip, only: [:show, :edit, :update, :destroy]

  def index
    # @trips = Trip.all
    @trips = policy_scope(Trip)
  end

  def show
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "show"   # Excluding ".pdf" extension.
      end
    end
  end

  def new
    @trip = Trip.new
    authorize @trip
  end

  def edit
    @disable_footer = true
    @activities = @trip.activities
    @trip_days = @trip.trip_days
    @trip_icons = set_day_icon(@trip_days)
    @activity = Activity.new
    @main_categories = MainCategory.all
    @map_hash = set_map_hash(@activities, @trip_icons) if @activities.length > 0
  end

  def create
    @trip = current_user.trips.build(trip_params)
    authorize @trip
    create_trip_days(params["trip"]["nb_days"].to_i, params["trip"]["description"].to_date)
    if @trip.save
      redirect_to @trip, notice: 'Trip was successfully created.'
    else
      render :new
    end
  end

  def create_trip_days(nb_days, start_date)
    day = start_date || Date.today
    nb_days.times do
      @trip.trip_days.build(title: day.strftime('%A'), date: day)
      @trip.save
      day = day.next
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
    authorize @trip
  end

  def trip_params
    params.require(:trip).permit(
      :title, :description, :category,
      :city, :country, :lat, :lon,
      :photo, :photo_cache, :public, :user_id
    )
  end
end
