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

  describe "create" do
    it "be able to create a new order" do
      order_data = {
        order: {
          status: "skydiving mars",
          email: 1.5,
          address: "adventure",
          name: "my_name",
          cc_name: "name",
          cc_exp: 20190708,
          cc_num: "1234321323432342",
        }
      }

      expect {
        post orders_path, params: order_data
      }.must_change "Order.count", +1

      must_respond_with :ok
    end
  end
end
