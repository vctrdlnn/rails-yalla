class ActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :edit, :update, :destroy, :change_position]
  # before_action :set_trip, only: [:new, :create]

  def index
    @activities = Activity.where.not(lat: nil, lon: nil)
    @iMarker = 1
    @hash = Gmaps4rails.build_markers @activities do |activity, marker|
      marker.lat activity.lat
      marker.lng activity.lon
      # marker.title @iMarker
      # marker.infowindow render_to_string(partial: "/activities/map_box", locals: { activity: activity })
    end
    # @hash.each_with_index { |key, index| key[:label] = (index + 1).to_s }
  end

  def show
    @activity_coordinates = { lat: @activity.lat, lng: @activity.lon }
  end

  def new
    @activity = Activity.new
  end

  def edit
    # redirect_to :back, notice: 'Activity was successfully updated.'
  end

  def create
    # @activity = @trip.activities.build(activity_params)
    @activity = Activity.new(activity_params)
    if @activity.save
      redirect_to edit_activity_path(@activity), notice: 'Activity was successfully created.'
    else
      render :new
    end
  end

  def update
    if @activity.update(activity_params)
      redirect_to activities_path, notice: 'Activity was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @activity.destroy
    redirect_to :back, notice: 'Activity was deleted.'
  end

  def change_position
    i = 1
    params["activity"]["index"] = params["activity"]["index"].to_i
    if params["activity"]["trip_day_id"].to_i == 0
      params["activity"]["trip_day_id"] = nil
    else
      params["activity"]["trip_day_id"] = params["activity"]["trip_day_id"].to_i
    end

    @activity.update(activity_params)

  end

  private

  def set_activity
    @activity = Activity.find(params[:id])
  end

  # def set_trip
  #   @trip = Trip.find(params[:trip_id])
  # end

  def activity_params
    params.require(:activity).permit(
      :title, :description, :main_category_id,
      :establishment, :city, :address,
      :lon, :lat, :index, :trip_id, :trip_day_id
    )
  end
end
