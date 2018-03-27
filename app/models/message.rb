class Message < ApplicationRecord
  belongs_to :user
  belongs_to :trip

  def posted_ago
    created_at.to_s(:humanized_ago)
  end
end
