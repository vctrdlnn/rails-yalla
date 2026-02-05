class ParticipantsController < ApplicationController
  before_action :set_participant, only: [:destroy]

  def destroy
    trip = @participant.trip
    @participant.destroy
    redirect_back(fallback_location: properties_trip_path(trip), notice: 'Participant was successfully deleted.')
  end

  private

  def set_participant
    @participant = Participant.find(params[:id])
    authorize @participant
  end
end
