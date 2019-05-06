class Product < ApplicationRecord
  belongs_to :merchant
  has_many :reviews
  has_and_belongs_to_many :categories
  has_many :order_items
  has_many :orders, -> { distinct }, through: :order_items

  validates :name, uniqueness: true, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }

  def change_status
      if status == "listed"
        status = "retired"
      else
        status = "listed"
      end
  end
end
