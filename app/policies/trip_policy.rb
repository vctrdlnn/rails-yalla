class TripPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      # scope c'est Trip
      scope.where(user: user) && scope.where(public: true)
    end
  end

  def create?
    true # tous les users peuvent creer un trip
  end

  def show?
    true # tous les users peuvent creer un trip
  end

  def send_trip?
    user_is_logged?
  end

  def update?
    user_is_owner_or_admin_or_participant?
  end

  def properties?
    user_is_owner_or_admin?
  end

  def chatroom?
    user_is_owner_or_admin_or_participant?
  end

  def destroy?
    user_is_owner_or_admin?
  end

  def like?
    !user_is_owner? && user_is_logged?
  end

  def make_my_day?
    user_is_owner_or_admin?
  end

  def map_markers?
    update?
  end

  private

  def user_is_owner_or_admin?
    # TODO: seul le user peut modifier le resto
    # record => @trip
    # user => current_user
    if user
      user.admin || record.user == user
    end
  end

  def user_is_owner_or_admin_or_participant?
    # TODO: seul le user peut modifier le resto
    # record => @trip
    # user => current_user
    if user
      user.admin || (record.user == user) || (record.participants.find_by(user: user))
    end
  end

  def user_is_logged?
    user
  end

  def user_is_owner?
    record.user == user if user
  end
end
