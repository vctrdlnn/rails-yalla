# Base class where we store all trips
class Trip < ApplicationRecord
  acts_as_votable

  belongs_to :user
  has_many :trip_days, dependent: :destroy
  has_many :activities, dependent: :destroy

  attr_accessor :nb_days, :start_date

  validates :title, presence: true
  validates :city, presence: true
  validates :category,
    inclusion: {

      in: ["Discovery", "Lovers", "Business", "Friends", "Bachelor(ette)", "Family", "Cultural"],

      message: "%{value} is not a valid category"
      }

  geocoded_by :address, latitude: :lat, longitude: :lon
  after_validation :geocode

  def address
    [city, country].compact.join(', ')
  end

  mount_uploader :photo, PhotoUploader

  def markers

  end

end
