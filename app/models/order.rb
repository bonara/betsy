# frozen_string_literal: true

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
    order_items.each do |order_item|
      sum += order_item.total
    end
    sum
  end
end
