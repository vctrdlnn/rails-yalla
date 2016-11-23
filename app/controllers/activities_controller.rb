class ActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :edit, :update, :destroy]
  before_action :set_trip, only: [:new, :create, :edit, :update]

  def index
    @activities = Activity.where.not(lat: nil, lon: nil)

    @hash = Gmaps4rails.build_markers(@activities) do |activity, marker|
      marker.lat activity.lat
      marker.lng activity.lon
      # marker.infowindow render_to_string(partial: "/flats/map_box", locals: { flat: flat })
    end
  end

  def show
    @activity_coordinates = { lat: @activity.lat, lng: @activity.lon }
  end

  def new
    @activity = Activity.new
  end

  def edit
  end

  def create
    @activity = @trip.activities.build(activity_params)
    if @activity.save
      redirect_to :back, notice: 'Activity was successfully created.'
    else
      render :new
    end
  end

  def update
    if @activity.update(activity_params)
      redirect_to :back, notice: 'Activity was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @activity.destroy
    redirect_to :back, notice: 'Activity was deleted.'
  end

  private

  def set_activity
    @activity = Activity.find(params[:id])
  end

  def set_trip
    @trip = Trip.find(params[:trip_id])
  end

  def activity_params
    params.require(:activity).permit(
      :title, :description, :category,
      :establishment, :city, :address,
      :lon, :lat, :index, :trip_id, :trip_day_id
    )
  end
end
