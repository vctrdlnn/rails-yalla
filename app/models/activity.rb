class Activity < ApplicationRecord
  belongs_to :trip
  belongs_to :trip_day

  validates :title, presence: true
  validates :address, presence: true
  validates :category, presence: true
end
