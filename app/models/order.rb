# frozen_string_literal: true

class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items

  validates :email, presence: true, if: :status_complete?
  validates :address, presence: true, if: :status_complete?
  validates :name, presence: true, if: :status_complete?
  validates :cc_name, presence: true, if: :status_complete?
  validates :cc_exp, presence: true, if: :status_complete?
  validates :cc_num, presence: true, if: :status_complete?

  def status_complete?
    status == 'complete'
  end

  def total
    sum = 0
    self.order_items.each do |item|
      sum = sum + (item.quantity * item.product.price)
    end
    return sum
  end

end
