# Base class where we store all trips
class Trip < ApplicationRecord
  acts_as_votable

  belongs_to :user, optional: true
  has_many :trip_days, -> { order "created_at ASC" }, dependent: :destroy
  has_many :activities, -> { order(:index) }, dependent: :destroy
  has_many :participants
  has_many :invites

  attr_accessor :nb_days, :start_date

  scope :unclaimed, -> { where.not(claim_token: nil) }
  scope :expired_unclaimed, -> { unclaimed.where("trips.created_at < ?", 30.days.ago) }

  before_create :generate_claim_token, if: -> { user_id.nil? }

  validates :title, presence: true
  validates :city, presence: true
  validates :category,
    inclusion: {
      in: ["Discovery", "Lovers", "Business", "Friends", "Bachelor", "Family", "Cultural"],
      message: "%{value} is not a valid category"
      }

  geocoded_by :city_address, latitude: :lat, longitude: :lon
  after_validation :geocode

  def city_address
    "#{city}, #{country}"
  end

  def all_members
    members = []
    emails = []
    # add participants
    self.participants.each do |participant|
      members <<
      {
        email: participant.user.email,
        user_id: participant.user.id,
        participant_id: participant.id,
        status: "member"
      }
      emails << participant.user.email
    end

    # add invites
    self.invites.each do |invite|
      unless emails.include?(invite.email)
        members <<
        {
          email: invite.email,
          invitation_id: invite.id,
          status: "invited"
        }
      end
    end
    members
  end

  mount_uploader :photo, PhotoUploader

  def markers
  end

  def likes
    self.votes_for.size
  end

  private

  def generate_claim_token
    self.claim_token = SecureRandom.hex(20)
  end
end
