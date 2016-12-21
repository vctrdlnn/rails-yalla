class InvitePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      # scope c'est Trip
      scope
    end
  end

  def create?
    true # tous les users peuvent creer un trip
  end

  def destroy?
    user_is_trip_owner?
  end

  private

  def user_is_trip_owner?
    record.trip.user == user if user
  end
end
