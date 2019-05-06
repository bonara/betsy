# frozen_string_literal: true

class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }

  # def add_quantity
  #   @order_item = OrderItem.find(params[:id])
  #   @order_item.quantity += 1
  #   @order_item.save
  #   redirect_to order_path(@order)
  # end

  # def reduce_quantity
  #   @order_item = OrderItem.find(params[:id])
  #   @order_item.quantity -= 1 if @order_item.quantity > 1
  #   @order_item.save
  #   redirect_to order_path(@order)
  # end

  # def total_price
  #   quantity * product.price
  # end
  
end
