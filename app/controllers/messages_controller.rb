class MessagesController < ApplicationController
  skip_after_action :verify_authorized

  def new
    @message = Message.new
    authorize @message
  end

  def create
    @message = current_user.messages.build(message_params)
    # authorize @message

    if @message.save
      respond_to do |format|
        format.html { redirect_to @message.trip, notice: 'Activity was successfully created.' }
        format.js  # <-- will render `app/views/reviews/create.js.erb`
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.js  # <-- idem
      end
    end
  end

  def destroy
  end

  def edit
  end

  def update
  end

  private

  def message_params
    params.require(:message).permit(
      :content, :trip_id
    )
  end
end
