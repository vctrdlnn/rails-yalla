# Base class where we store all trips
class Trip < ApplicationRecord
  belongs_to :user
  has_many :trip_days, dependent: :destroy
  has_many :activities, dependent: :destroy

  validates :title, presence: true
  validates :category, presence: true
  validates :city, presence: true
end
