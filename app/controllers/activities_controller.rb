class ActivitiesController < ApplicationController
  include MapsHashConcern
  before_action :set_activity, only: [:show, :edit, :update, :destroy, :change_position]
  # before_action :set_trip, only: [:new, :create]
  before_filter :sanitize_activity_params, only: [:change_position]

  def index
    @activities = Activity.where.not(lat: nil, lon: nil)
    @activities = policy_scope(Activity)
    @hash = set_map_hash(@activities)
  end

  def show
    @activity_coordinates = { lat: @activity.lat, lng: @activity.lon }
  end

  def new
    @activity = Activity.new
  end

  def new_act
    @activity = Activity.new
  end

  def edit
  end

  def create
    # @activity = @trip.activities.build(activity_params)
    @activity = Activity.new(activity_params)
    @activity.title = "Visit of " + @activity.establishment if @activity.title.nil?
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
    increment_next_index(next_activities(@activity), @activity.index, 0)
    @activity.update(activity_params)
    increment_next_index(next_activities(@activity), @activity.index, +1)
  end

  private

  def next_activities(activity)
    if activity.trip_day.nil?
      other_activities = activity.trip.activities.where(trip_day: nil)
    else
      other_activities = activity.trip_day.activities
    end
    next_activities = other_activities
      .order(index: :asc)
      .where("index >= ?", activity.index)
      .where.not(id: activity.id)
  end

  def increment_next_index(activities, start_id, inc)
    start_id ? new_idx = [start_id + inc, 1].max : new_idx = 1
    activities.each do |act|
      act.index = new_idx
      act.save
      new_idx += 1
    end
  end

  def set_activity
    @activity = Activity.find(params[:id])
    authorize @activity
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

  def sanitize_activity_params
    params["activity"]["index"] = params["activity"]["index"].to_i
    if params["activity"]["trip_day_id"].to_i == 0
      params["activity"]["trip_day_id"] = nil
    else
      params["activity"]["trip_day_id"] = params["activity"]["trip_day_id"].to_i
    end
  end
end
