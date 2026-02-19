module PendingTripCreation
  extend ActiveSupport::Concern

  def create_pending_trip_for_user(user)
    return nil unless session[:pending_trip].present?

    trip_params = session[:pending_trip].except("nb_days", "start_date", "invite_emails")
    trip = user.trips.build(trip_params.permit!)

    nb_days = (session[:pending_trip]["nb_days"].to_i.zero? ? 3 : session[:pending_trip]["nb_days"].to_i)
    start_date = session[:pending_trip]["start_date"].present? ? Date.parse(session[:pending_trip]["start_date"]) : Date.today

    day = start_date
    [nb_days, 3].max.times do
      trip.trip_days.build(title: day.strftime('%A'), date: day)
      day = day.next
    end

    if trip.save
      process_pending_invites(trip, user, session[:pending_trip]["invite_emails"])
      session.delete(:pending_trip)
      trip
    else
      session.delete(:pending_trip)
      nil
    end
  end

  private

  def process_pending_invites(trip, user, emails_string)
    return if emails_string.blank?

    emails = emails_string.split(",").map(&:strip).reject(&:blank?)
    emails.each do |email|
      invite = trip.invites.build(email: email, sender_id: user.id)
      if invite.save
        if invite.recipient.present?
          InviteMailer.existing_user_invite(invite).deliver_later
          invite.recipient.participants.create(trip: trip, role: "Editor")
        else
          InviteMailer.new_user_invite(invite, new_user_registration_url(invite_token: invite.token)).deliver_later
        end
      end
    end
  end
end
