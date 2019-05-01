class Product < ApplicationRecord
  belongs_to :merchant
  has_many :reviews
  has_and_belongs_to_many :categories
end
