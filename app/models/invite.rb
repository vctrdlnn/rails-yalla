class Invite < ApplicationRecord
  belongs_to :trip
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  before_create :generate_token
  before_save :check_user_existence

  validates :email,
    presence: true,
    uniqueness: {
      scope: :trip,
      message: "User can only be invited once per trip"
    }

  private

  def check_user_existence
    recipient = User.find_by_email(email)
   if recipient
      self.recipient_id = recipient.id
   end
 end

  def generate_token
    self.token = Digest::SHA1.hexdigest([self.trip_id, Time.now, rand].join)
  end
end
