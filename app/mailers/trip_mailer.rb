class TripMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.trips_mailer.welcome.subject
  #

  def send_trip(trip, user)
    @trip = trip
    @user = user
    mail  to: @user.email,
          subject: "Hi #{@user.name}, details of #{@trip.title}"

  end
end
