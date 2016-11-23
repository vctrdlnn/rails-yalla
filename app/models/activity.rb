# Activity defines individual activities that a user is planning to do at a trip
# Activities are small cards that will be sorted day by day
class Activity < ApplicationRecord
  belongs_to :trip
  belongs_to :trip_day, optional: true

  validates :title, presence: true
  # validates :address, presence: true
  validates :category, presence: true
end
