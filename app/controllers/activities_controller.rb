class ActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :edit, :update, :destroy, :change_position, :pin]
  # before_action :set_trip, only: [:new, :create]
  before_action :sanitize_activity_params, only: [:change_position]


  def index
    @activities = Activity.where.not(lat: nil, lon: nil)
    @activities = policy_scope(Activity)
    @hash = set_map_hash(@activities)
    @activity = Activity.new
    @main_categories = MainCategory.all
  end

  def show
    @activity_coordinates = { lat: @activity.lat, lng: @activity.lon }
  end

  def new
    @activity = Activity.new
    authorize @activity
  end

  def edit
    @main_categories = MainCategory.all
  end

  def create
    @activity = current_user.activities.build(activity_params)
    p activity_params
    @activity.index = 1 # TODO : REMOVE THIS
    authorize @activity
    set_title if @activity.title.nil?
    find_main_category unless (@activity.google_category.nil? || !@activity.main_category.nil?)
    if !params["trip_id"].nil?
      set_trip
      @activity.trip = @trip
    end
    if @activity.save
      respond_to do |format|
        format.html { redirect_to edit_activity_path(@activity), notice: 'Activity was successfully created.' }
        format.js  # <-- will render `app/views/reviews/create.js.erb`
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.js  # <-- idem
      end
    end
  end

  def update
    if @activity.update(activity_params)
      respond_to do |format|
        format.html { redirect_to :back, notice: 'Activity was successfully updated.' }
        format.js # <-- will render 'app/views/reviews/update.js.erb'
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.js  # <-- idem
      end
    end
  end

  def copy
    @activity = Activity.find(params["activity_id"]).dup
    authorize @activity
    @activity.parent_id = params["activity_id"]
    @activity.trip_id = params["trip_id"]
    @activity.trip_day_id = nil
    if current_user
      @activity.user = current_user
    end
    if @activity.save
      respond_to do |format|
        format.html { redirect_to :back, notice: 'Activity was successfully added to the trip.' }
        format.js  # <-- will render `app/views/reviews/create.js.erb`
      end
    else
      respond_to do |format|
        format.html { redirect_to :back, alert: @activity.errors.messages }
        format.js  # <-- idem
      end
    end
  end

  def pin
    # @pinned_activity = current_user.pinned_activities.build(activity_id: params["id"])
    # if @pinned_activity.save
    #   respond_to do |format|
    #     format.html { redirect_to :back, notice: 'Activity saved.' }
    #     format.js  # <-- TODO: will render `app/views/reviews/pin.js.erb`
    #   end
    # end
  end

  def destroy
    @activity.destroy
  end

  def change_position
    increment_next_index(next_activities(@activity), @activity.index, 0)
    @activity.update(activity_params)
    increment_next_index(next_activities(@activity), @activity.index, +1)
  end

  private

  def find_main_category
    if Category.find_by(google_title: @activity.google_category).nil?
      @activity.main_category =  MainCategory.find_by(title: "Others")
    else
      @activity.main_category =  Category.find_by(google_title: @activity.google_category).main_category
    end
  end

  def set_title
      if @activity.establishment.nil?
        @activity.title = @activity.main_category.title + " time around " + @activity.address
      else
        @activity.title = "Visit of " + @activity.establishment
      end
  end

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

  def set_trip
    @trip = Trip.find(params[:trip_id])
  end

  def activity_params
    params.require(:activity).permit(
      :title, :description, :main_category_id,
      :establishment, :city, :address,
      :lon, :lat, :index, :trip_id, :trip_day_id,
      :google_category, :google_place_identifier,
      :photo, :photo_cache, :url
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
