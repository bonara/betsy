require 'test_helper'

describe OrdersController do
  describe 'index' do
    it 'succeeds when there are orders' do
      get orders_path

      must_respond_with :success
    end

    it 'succeeds when there are no orders' do
      Order.all do |order|
        order.destroy
      end

      get orders_path

      must_respond_with :success
    end
  end

  describe 'new' do
    it 'succeeds' do
      get new_order_path

      must_respond_with :success
    end
  end

  describe 'show' do
    it "returns a 404 status code if the order doesn't exist" do
      order_id = 122345

      get order_path(order_id)

      must_respond_with :not_found

    end

    it "works for an order that exists" do
      order = Order.create!(status: "pending")

      get "/orders/#{order.id}"

      must_respond_with :success
    end
  end

  describe "edit" do
    it "succeeds for an existing order ID" do
      order = Order.create!(status: "pending")

      get edit_order_path(order.id)

      must_respond_with :success
    end

    it "renders 404 not_found for a bogus order ID" do
      order_id = 987736

      get edit_order_path(order_id)

      must_respond_with :not_found
    end
  end

  describe "destroy" do
    it 'removes all order items from order' do
      
      order = Order.create

      product = Product.first

      order_item = OrderItem.create!(
        order_id: order.id, 
        product_id: product.id,
        quantity: 2
      )

      expect(order.order_items.length).must_equal 1

      delete order_path(order)

      after_delete = Order.find(order.id)

      expect(after_delete.order_items.length).must_equal 0

      must_respond_with :redirect

    end

    it 'returns a 404 if the order does not exist' do
      order_id = 182939

      delete order_path(order_id)

      must_respond_with :not_found

    end
  end

  describe "create" do
    it "be able to create a new order with no existing order" do
      product = Product.first

      order_hash = {
        order_item: {
          product_id: product.id,
          quantity: 2,
        }
      }
    
      post orders_path, params: order_hash

      order_item = OrderItem.find_by(product_id: product.id)

      expect(order_item.product).must_equal product
      expect(order_item.quantity).must_equal 2
    end

    it "be able to create a new order WITH existing order" do

      product = Product.first

      order_hash = {
        order_item: {
          product_id: product.id,
          quantity: 2,
        }
      }
    
      post orders_path, params: order_hash
      post orders_path, params: order_hash

      order_item = OrderItem.find_by(product_id: product.id)

      expect(order_item.product).must_equal product
      expect(order_item.quantity).must_equal 4

    end
  end

  describe 'update' do 
    it 'Can purchase a product' do
      product = Product.first

      stock = product.stock
      price = product.price

      order_hash = {
        order_item: {
          product_id: product.id,
          quantity: 2,
        }
      }

      post orders_path, params: order_hash

      order_item = OrderItem.find_by(product_id: product.id)

      update_hash = {
        order: {
          email: 'test@email.com',
          address: 'random address',
          name: 'Jack',
          cc_name: 'Jackie',
          cc_exp: 20190501,
          cc_num: 12345432112344321
        }
      }

      patch order_path(order_item.order_id), params: update_hash

      expect(order_item.product.stock).must_equal 48
      expect(order_item.order.status).must_equal 'paid'

    end
    
    it 'Payment will not go through if the stock is less than quantity' do

      product = Product.first

      order_hash = {
        order_item: {
          product_id: product.id,
          quantity: 1,
        }
      }
      post orders_path, params: order_hash
      
      order_item = OrderItem.find_by(product_id: product.id)

      order_item.quantity = 51

      order_item.save

      update_hash = {
        order: {
          status: 'paid',
          email: 'test@email.com',
          address: 'random address',
          name: 'Jack',
          cc_name: 'Jackie',
          cc_exp: 20190501,
          cc_num: 12345432112344321
        }
      }

      patch order_path(order_item.order_id), params: update_hash

      must_respond_with :bad_request

    end
  end

end
