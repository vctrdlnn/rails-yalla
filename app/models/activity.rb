# Activity defines individual activities that a user is planning to do at a trip
# Activities are small cards that will be sorted day by day
class Activity < ApplicationRecord
  belongs_to :trip
  belongs_to :trip_day, optional: true
  belongs_to :main_category
  belongs_to :user
  has_many :pinned_activities, dependent: :destroy

  validates :title, presence: true
  validates :address, presence: true
  # validates :main_category_id, presence: true

  geocoded_by :address, latitude: :lat, longitude: :lon
  after_validation :geocode, if: :address_changed?
end
