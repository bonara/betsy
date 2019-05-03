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

      get orderss_path

      must_respond_with :success
    end
  end

  describe 'new' do
    it 'succeeds' do
      get new_order_path

      must_respond_with :success
    end
  end

  describe 'create' do
    it 'creates an order with valid data for a real category' do
      new_order = {
        order: {
          status: 'Pending',
          email: 'album@rest.com',
          address: '1234 hot street',
          name: 'John',
          cc_name: 'John Wick',
          cc_exp: 1122,
          cc_num: '123454323456'
              }
                  }

      expect {
        post orders_path, params: new_order
      }.must_change 'Order.count', 1

      new_order_id = Order.find_by(email: 'album@rest.com').id

      must_respond_with :redirect
      must_redirect_to order_path(new_order_id)
    end

    it 'renders bad_request and does not update the DB for bogus data' do
      new_order = { 
        order: {
           status: nil, 
           cc_exp: nil,
           cc_num: nil
           } 
          }

      expect {
        post orders_path, params: bad_order
      }.wont_change 'Order.count'

      must_respond_with :bad_request
    end

    describe 'show' do
      it 'succeeds for an existing order ID' do
        get order_path(existing_order.id)

        must_respond_with :success
      end

      it 'renders 404 not_found for a bogus order ID' do
        destroyed_id = existing_order.id
        existing_order.destroy

        get order_path(destroyed_id)

        must_respond_with :not_found
      end
    end
  end
end
