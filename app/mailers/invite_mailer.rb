class InviteMailer < ApplicationMailer
  # https://coderwall.com/p/rqjjca/creating-a-scoped-invitation-system-for-rails


  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invite_mailer.new_user_invite.subject
  #
  def new_user_invite(invite, invite_path)
    @greeting = "Hi"
    @invite = invite
    @invite_path = invite_path

    mail to: @invite.email,
          subject: "#{@invite.sender.name} has invited you to participate to #{@invite.trip.title}"
  end
end
