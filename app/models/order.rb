class Order < ApplicationRecord
  has_many :order_items
  has_many :products, through: :order_items

  validates :email, presence: true, on: :update
  validates :address, presence: true, on: :update
  validates :name, presence: true, on: :update
  validates :cc_name, presence: true, on: :update
  validates :cc_exp, presence: true, on: :update
  validates :cc_num, presence: true, on: :update
end
