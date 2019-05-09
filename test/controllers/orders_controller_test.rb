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

  # it 'can update an existing task' do
  #   task = Task.create!(name: 'Do dishes')
  #   task_data = {
  #     task: {
  #       name: "Don't do dishes"
  #     }
    

  #   patch task_path(task), params: task_data

  #   must_respond_with :redirect
  #   must_redirect_to task_path(task)

  #   task.reload
  #   expect(task.name).must_equal(task_data[:task][:name])
  # end

  # it 'will redirect to the root page if given an invalid id' do
  #   get task_path(-1)

  #   must_respond_with :redirect
  #   must_redirect_to tasks_path
  # end

end
