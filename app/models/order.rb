class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items
  
  validates :name, presence: true, on: :update
  validates :email, presence: true, on: :update
  validates :address, presence: true, on: :update
  validates :cc_num, presence: true, on: :update
  validates :cc_name, presence: true, on: :update
  validates :cc_exp, presence: true, on: :update

  def sub_total
    sum = 0
    self.order_items.each do |order_item|
      sum+= order_item.total_price
    end
    return sum
  end
  
end

validates :cc_name, presence: true,  on: :update
validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :update }
validates :cc_num, presence: true, format: { with: /\A\d+\z/ , on: :update }
validates :cvv, presence: true, numericality: {greater_than_or_equal_to: 0, only_integer: true, on: :update }
validates :address, presence: true, on: :update

end


