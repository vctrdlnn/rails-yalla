# days belonging to trips to which we assign activities when sorting them out
class TripDay < ApplicationRecord
  belongs_to :trip
  has_many :activities, dependent: :destroy
end
