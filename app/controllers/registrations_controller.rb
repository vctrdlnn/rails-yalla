class RegistrationsController < Devise::RegistrationsController
  private

  def after_update_path_for(resource)
    edit_user_registration_path
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def account_update_params
    params.require(:user).permit(:username, :mobile, :photo, :photo_cache, :hometown)
  end
end
