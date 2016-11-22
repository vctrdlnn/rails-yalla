class Trip < ApplicationRecord
  belongs_to :user
  has_many :trip_days
  has_many :activities

  validates :title, presence: true
  validates :category, presence: true
  validates :city, presence: true
end
