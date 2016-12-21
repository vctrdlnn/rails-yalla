class ParticipantsController < ApplicationController
  before_action :set_participant, only: [:destroy]

  def destroy
    @participant.destroy
    redirect_to :back, notice: 'Participant was successfully deleted.'
  end

  private

  def set_participant
    @participant = Participant.find(params[:id])
    authorize @participant
  end
end
