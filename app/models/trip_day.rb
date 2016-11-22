class TripDay < ApplicationRecord
  belongs_to :trip
  has_many :activities
end
