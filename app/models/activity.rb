# Activity defines individual activities that a user is planning to do at a trip
# Activities are small cards that will be sorted day by day
class Activity < ApplicationRecord
  belongs_to :trip
  belongs_to :trip_day, optional: true
  belongs_to :main_category
  belongs_to :user

  has_many :pinned_activities, dependent: :destroy

  has_many :copies, class_name: "Activity",
                          foreign_key: "parent_id"
  belongs_to :parent, optional: true, class_name: "Activity"

  validates :title, presence: true
  validates :address, presence: true
  # validates :main_category_id, presence: true
  # TODO: Control that parent_id unique in scope trip_id
  # validates :parent, uniqueness: { scope: :trip,
  #   message: "You have already saved this activity" }

  # REMOVE GEOCODING - COMES FROM GMAPS DIRECTLY
  # geocoded_by :address, latitude: :lat, longitude: :lon
  # after_validation :geocode, if: :address_changed?

  mount_uploader :photo, PhotoUploader
end
