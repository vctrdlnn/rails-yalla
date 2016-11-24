class RegistrationsController < Devise::RegistrationsController

  private

  def account_update_params
    params.require(:user).permit(:username, :mobile, :photo, :hometown)
  end
end
