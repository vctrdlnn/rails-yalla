# Trip controller - classic CRUD so far
class TripsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show, :send_trip, :search ]
  before_action :set_trip, only: [:show, :send_trip, :edit, :update, :destroy, :like, :make_my_day, :map_markers, :properties]

  skip_after_action :verify_authorized, only: [:my_trips, :search]

  def index
    # @trips = Trip.all
    @trips = policy_scope(Trip)
    @trips = @trips.sort { |x, y| y.activities.count <=> x.activities.count }
    @trips = @trips.sort { |x, y| y.cached_votes_total <=> x.cached_votes_total }
  end

  def search
    @trips = policy_scope(Trip)
    @trips = @trips.near(params["trip"]["city"], 100)
    @trips = @trips.sort { |x, y| y.activities.count <=> x.activities.count }
    @trips = @trips.sort { |x, y| y.cached_votes_total <=> x.cached_votes_total }
    render :index
  end

  def my_trips
    @trips = []
    @trips += current_user.trips
    current_user.participants.each do |participation|
      @trips << participation.trip unless @trips.include?(participation.trip)
    end
    @trips += current_user.find_voted_items
  end

  def show
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "show"   # Excluding ".pdf" extension.
      end
    end
  end

  def send_trip
    if current_user.nil? #TODO: Render something if no user
      redirect_to @trip, alert: "Please login or signup to receive emails"
    else
      TripMailer.send_trip(@trip, current_user).deliver_now
      redirect_to @trip, notice: "Email successfully sent"
    end
  end

  def new
    @trip = Trip.new
    @trip.start_date = Date.today
    authorize @trip
  end

  def edit
    @activity = Activity.new
    @main_categories = MainCategory.all
  end

  def properties
    @invite = Invite.new
  end

  def create
    @trip = current_user.trips.build(trip_params)
    authorize @trip
    params["trip"]["nb_days"].to_i == 0 ? nb_days = 3 : nb_days = params["trip"]["nb_days"].to_i
    create_trip_days(nb_days, params["trip"]["start_date"].to_date)
    if @trip.save
      # Process invite emails if provided
      process_invite_emails if params[:invite_emails].present?
      redirect_to edit_trip_path(@trip), notice: 'Trip was successfully created.'
    else
      render :new
    end
  end

  def create_trip_days(nb_days, start_date)
    day = start_date || Date.today
    days = [nb_days, 3].max
    days.times do
      @trip.trip_days.build(title: day.strftime('%A'), date: day)
      @trip.save
      day = day.next
    end
  end

  def update
    if @trip.update(trip_params)
      redirect_to edit_trip_path(@trip), notice: 'Trip was successfully updated.'
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
    result = TripClusteringService.new(@trip).call
    if result.success?
      redirect_to edit_trip_path(@trip), notice: "Your itinerary has been optimized!"
    else
      redirect_back(fallback_location: edit_trip_path(@trip), alert: result.message)
    end
  end

  def map_markers
    respond_to do |format|
      format.json
    end
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
      :photo, :photo_cache, :remote_photo_url, :public
    )
  end

  def process_invite_emails
    emails = params[:invite_emails].split(",").map(&:strip).reject(&:blank?)
    emails.each do |email|
      invite = @trip.invites.build(
        email: email,
        sender_id: current_user.id
      )
      if invite.save
        if invite.recipient.present?
          InviteMailer.existing_user_invite(invite).deliver_later
          invite.recipient.participants.create(trip: @trip, role: "Editor")
        else
          InviteMailer.new_user_invite(invite, new_user_registration_url(invite_token: invite.token)).deliver_later
        end
      end
    end
  end
end
