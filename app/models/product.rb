class Product < ApplicationRecord
  belongs_to :merchant
  has_many :reviews
  has_and_belongs_to_many :categories
  has_many :order_items
  has_many :orders, -> { distinct }, through: :order_items

  validates :name, uniqueness: true, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  
  def avrg_rating
    unless self.reviews.count == 0
      total_rating = self.reviews.map{|review| review.rating}.compact.sum
      avrg = total_rating/self.reviews.count
    end
    return avrg
  end
end
