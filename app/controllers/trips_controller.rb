# Trip controller - classic CRUD so far
class TripsController < ApplicationController
  include MapsHashConcern
  skip_before_action :authenticate_user!, only: [:index, :show ]
  before_action :set_trip, only: [:show, :edit, :update, :destroy, :like, :make_my_day]

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
    @activities = @trip.activities.order(:lat, :lon)
    @trip_days = @trip.trip_days
    @trip_icons = set_day_icon(@trip_days)
    @activity = Activity.new
    @main_categories = MainCategory.all
    @map_hash = set_map_hash(@activities, @trip_icons) if @activities.length > 0
  end

  def create
    @trip = current_user.trips.build(trip_params)
    authorize @trip
    create_trip_days(params["trip"]["nb_days"].to_i, params["trip"]["start_date"].to_date)
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

  def like
    if current_user.voted_for? @trip
      current_user.unvote_for @trip
    else
      current_user.up_votes @trip
    end
  end

  def make_my_day
    shortest_trip_days(@trip)
    redirect_to edit_trip_path(@trip), notice: 'Magic has happen, this is the best itinirary!'
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


  # MAKE MY DAY ALGORITHM

  def shortest_trip_days(trip)
    points = trip.activities.map{ |a| {id: a.id, lat: a.lat, lon: a.lon} }
    shortest_solution = best_path(points, trip.trip_days.length)
    day_index = 0
    shortest_solution.each_pair do |key, value|
      value.each_with_index do |act, i|
        activity = Activity.find(act[:id])
        activity.trip_day_id = trip.trip_days[day_index].id
        activity.index = i + 1
        activity.save
      end
      day_index += 1
    end
  end

  def best_path(points, days)
    days = 3
    if points.length < days * 2
      return nil
    end
    possible_trips = all_combinaisons(points, days)
    shortest = possible_trips.values.min_by { |trip| distance(trip[:day1]) + distance(trip[:day2]) + distance(trip[:day3]) }
  end

  def all_combinaisons(points, days)
    combos = {}
    i = 1
    a_max = points.length - 2 * (days - 1)

    (2..a_max).each do |a|
      points_a = points
      combos[i] = {} if combos[i].nil?
      # find which combination of a length is the shortest to only iterate on this one
      combos[i][:day1] = points_a.combination(a).to_a.min_by { |route| distance(route) }

      # TODO: rendre le truc iteratif et repasser dans le code au dessus mais avec le nouveau subpoint
      # les points d'origine sont en fait le sous ensemble et on le fait sur 2 jours au lieu de 3
      points_b = points_a - combos[i][:day1]
      b_max = points_b.length - 2 * (days - 2)
      (2..b_max).each do |b|
        if combos[i].nil?
          combos[i] = {}
          combos[i][:day1] = combos[i-1][:day1]
        end
        # find which combination of b length is the shortest to only iterate on this one
        combos[i][:day2] = points_b.combination(b).to_a.min_by { |route| distance(route) }

        # C can only be the remaining!
        combos[i][:day3] = points_b - combos[i][:day2]

        # TODO: if 4 days or more
        # points_c = points_b - combos[i][:day2]
        # c_max = points_c.length
        # (2..c_max).each do |c|
        #   if combos[i].nil?
        #     combos[i][:day1] = combos[i-1][:day1]
        #     combos[i][:day2] = combos[i-1][:day2]
        #   end
        #   combos[i][:day3] = points_c.combination(c).to_a.min_by { |route| distance(route) }
        # end

          i += 1
      end
    end
    return combos
  end

  def distance(points)
    sum = 0
    if points.length >= 2
      points.each_cons(2) do |a, b|
        sum += Math.sqrt((b[:lat] - a[:lat])**2 + (b[:lon] - a[:lon])**2)
      end
    end
    return sum
  end
end
