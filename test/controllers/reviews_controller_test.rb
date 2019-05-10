# frozen_string_literal: true

require 'test_helper'

describe OrderItemsController do
  describe 'update' do
    it 'can update an item quantity' do
      order_item_data = {
        order_item: {
          quantity: '5',
          product_id: 1
        }
      }
      before = OrderItem.count

      expect do
        post order_items_path, params: order_item_data
      end

      expect(OrderItem.count).must_equal before + 1

      expect(flash[:result_text]).must_include "Successfully updated #{@order_item.id} quantity"
      must_respond_with :ok
    end
  end

  #   describe 'destroy' do
  #     it 'can delete an order item' do
  #         order_item_data = {
  #           order: {
  #             quantity: '5',
  #             product_id: 1
  #           }
  #         }

  #       before = OrderItem.count

  #       expect do
  #         post order_item_path, params: order_item_data
  #       end

  #       expect(OrderItem.count).must_equal before - 1

  #       must_redirect_to root_path
  #     end
  #   end
  #   describe "destroy" do
  #     it "can destroy an existing product" do

  #       expect {
  #         delete product_path(product)
  #       }.must_change('Product.count', -1)

  #       must_redirect_to products_path
  #     end
  #   end
end
