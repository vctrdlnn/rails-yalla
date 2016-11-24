class MainCategory < ApplicationRecord
  has_many :categories
  has_many :activities
end
