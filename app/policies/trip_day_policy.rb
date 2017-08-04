class TripDayPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    user_is_admin? # tous les users peuvent creer un trip
  end

  private

  def user_is_admin?
    # TODO: seul le user peut modifier le resto
    # record => @trip
    # user => current_user
    if user
      user.admin
    end
  end

end
