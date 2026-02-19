# Trip controller - classic CRUD so far
class TripsController < ApplicationController
  include GuestTripAccess

  skip_before_action :authenticate_user!, only: [:index, :show, :send_trip, :search, :new, :create, :edit, :map_markers]
  before_action :set_trip, only: [:show, :send_trip, :like, :update, :destroy, :make_my_day, :properties]
  before_action :set_trip_for_guest, only: [:edit, :map_markers]

  skip_after_action :verify_authorized, only: [:my_trips, :search]

  def index
    @trips = policy_scope(Trip)
              .includes(:user, :activities)
              .left_joins(:activities)
              .group("trips.id")
              .order("cached_votes_total DESC, COUNT(activities.id) DESC")
  end

  def search
    @trips = policy_scope(Trip)
              .near(params["trip"]["city"], 100)
              .includes(:user, :activities)
              .left_joins(:activities)
              .group("trips.id")
              .order("cached_votes_total DESC, COUNT(activities.id) DESC")
    render :index
  end

  def my_trips
    trip_ids = current_user.trip_ids +
               current_user.participants.pluck(:trip_id) +
               current_user.find_voted_items.map(&:id)
    @trips = Trip.where(id: trip_ids.uniq).includes(:user, :activities)
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
    authenticate_user_or_guest!
    @activity = Activity.new
    @main_categories = MainCategory.all
    @unclaimed = @trip.claim_token.present?
  end

  def properties
    @invite = Invite.new
  end

  def create
    if user_signed_in?
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
    else
      # Guest flow: create real trip in DB with no user
      @trip = Trip.new(trip_params)
      @trip.public = false
      authorize @trip
      if @trip.valid?
        params["trip"]["nb_days"].to_i == 0 ? nb_days = 3 : nb_days = params["trip"]["nb_days"].to_i
        create_trip_days(nb_days, params["trip"]["start_date"].to_date)
        if @trip.save
          session[:claim_token] = @trip.claim_token
          session[:claimed_trip_id] = @trip.id
          redirect_to edit_trip_path(@trip), notice: 'Trip created! Sign up anytime to save it.'
        else
          render :new
        end
      else
        render :new
      end
    end
  end

  def create_trip_days(nb_days, start_date)
    day = start_date || Date.today
    days = [nb_days, 1].max
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
    authenticate_user_or_guest!
    respond_to do |format|
      format.json
    end
  end

  private

  def set_trip
    @trip = Trip.includes(trip_days: { activities: :main_category }, activities: :main_category)
               .find(params[:id])
    authorize @trip
  end

  def set_trip_for_guest
    @trip = Trip.includes(trip_days: { activities: :main_category }, activities: :main_category)
               .find(params[:id])
    authorize_or_skip_for_guest!(@trip)
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
