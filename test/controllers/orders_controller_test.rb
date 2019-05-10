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

      # Assert
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
    it 'removes the order from the database' do
      order = Order.new

      product = Product.new

      order_item = OrderItem.create(
        order_id: order.id, 
        product_id: product.id
      )

      expect do
        delete order_path(order.id)
      end.must_change 'Order.order_items.count', -1

      must_respond_with :success
      must_redirect_to fallback_location: root_path
    end

    it 'returns a 404 if the order does not exist' do
      order = 182939

      product = Product.new

      order_item = OrderItem.create(
        order_id: order, 
        product_id: product
      )

      expect do
        delete order_path(order)
      end.wont_change 'Order.count'

      must_respond_with :not_found

    end
  end

  describe "create" do
    it "be able to create a new order" do
      order = Order.new

      product = Product.new

      order_item = OrderItem.create(
        order_id: order.id, 
        product_id: product.id
      )

        expect do
          post tasks_path, params: task_hash
        end.must_change 'Task.count', 1
  
        new_task = Task.find_by(name: task_hash[:task][:name])
        expect(new_task.description).must_equal task_hash[:task][:description]
        expect(new_task.completion_date.strftime('%Y-%m-%d')).must_equal task_hash[:task][:completion_date]
        expect(new_task.is_complete).must_equal false
  
        must_respond_with :redirect
        must_redirect_to task_path(new_task.id)
      end
      expect {
        post products_path, params: product_data
      }.must_change "Product.count", +1

  
      must_respond_with :redirect
      must_redirect_to products_path
    end
  end

  it 'can update an existing task' do
    task = Task.create!(name: 'Do dishes')
    task_data = {
      task: {
        name: "Don't do dishes"
      }
    }

    patch task_path(task), params: task_data

    must_respond_with :redirect
    must_redirect_to task_path(task)

    task.reload
    expect(task.name).must_equal(task_data[:task][:name])
  end

  it 'will redirect to the root page if given an invalid id' do
    get task_path(-1)

    must_respond_with :redirect
    must_redirect_to tasks_path
  end

end
