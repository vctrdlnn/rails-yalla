# Controller trip days
class TripDaysController < ApplicationController
  before_action :set_tripday, only: [:show, :edit, :update, :destroy]
  before_action :set_trip, only: [:new, :create, :edit, :update]

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
      redirect_to :back, notice: 'Trip day was successfully updated.'
    else
      render :edit
    end
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
