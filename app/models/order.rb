class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items

  def sub_total
    sum = 0
    self.order_items.each do |order_item|
      sum += order_item.total_price
    end
    return sum
  end

  private

  def update_status
    if self.status == nil?
      self.status = "In progress"
    end
  end

end

