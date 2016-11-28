# Base class where we store all trips
class Trip < ApplicationRecord
  belongs_to :user
  has_many :trip_days, dependent: :destroy
  has_many :activities, dependent: :destroy

  attr_accessor :nb_days, :start_date

  validates :title, presence: true
  # validates :category, presence: true
  validates :city, presence: true
  validates :category,
    inclusion: {
      in: ["Lovers", "Business", "Backpacker", "Friends", "Bachelorette", "Bachelor", "Family", "Cultural"],
      message: "%{value} is not a valid category"
      }

  mount_uploader :photo, PhotoUploader

end
