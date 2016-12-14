class Invite < ApplicationRecord
  belongs_to :trip
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  before_create :generate_token

  private

  def generate_token
    self.token = Digest::SHA1.hexdigest([self.trip_id, Time.now, rand].join)
  end
end
