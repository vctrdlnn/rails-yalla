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

end
