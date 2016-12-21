class Participant < ApplicationRecord
  belongs_to :user
  belongs_to :trip

  validates :role,
    inclusion: {
      in: ["Owner", "Editor", "Viewer"],
      message: "%{value} is not a valid role"
      }
  validates :user,
    uniqueness: {
      scope: :trip,
      message: "Can be added only once per trip"
    }
end
