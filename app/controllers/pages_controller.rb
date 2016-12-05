class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  skip_after_action :verify_authorized
  def home
    @trips = policy_scope(Trip)
    @trips = @trips.sort { |x, y| y.likes <=> x.likes }
    @trips = @trips.first(4)
  end
end
