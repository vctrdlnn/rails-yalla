# Controller trip days
class TripDaysController < ApplicationController
  before_action :set_tripday, only: [:show, :edit, :update, :destroy, :update_title]
  before_action :set_trip, only: [:new, :create, :edit, :update]
  skip_after_action :verify_authorized

  def index
    @trip_days = TripDay.all
  end

  def show
  end

  def new
    @trip_day = TripDay.new
  end

  def edit
  end

  def create
    @trip_day = @trip.trip_days.build(tripday_params)
    if @trip_day.save
      redirect_to :back, notice: 'Trip day was successfully created.'
    else
      render :new
    end
  end

  def update
    if @trip_day.update(tripday_params)
      respond_to do |format|
        format.html { redirect_to :back, notice: 'Title was successfully updated.' }
        format.js # <-- will render 'app/views/reviews/update.js.erb'
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.js  # <-- idem
      end
    end
  end

  def update_title
    @trip_day.update(tripday_params)
    # flash[:notice] =  "Title was successfully updated."
  end

  def destroy
    @trip_day.destroy
    redirect_to :back, notice: 'Trip day was successfully deleted.'
  end

  private

  def tripday_params
    params.require(:trip_day).permit(:title, :date, :trip_id)
  end

  def set_tripday
    @trip_day = TripDay.find(params[:id])
  end

  def set_trip
    @trip = Trip.find(params[:trip_id])
  end
end
