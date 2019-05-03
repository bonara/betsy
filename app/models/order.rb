class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items

  private

  def update_status
    if self.status == nil?
      self.status = "In progress"
    end
  end

end

