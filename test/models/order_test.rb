require "test_helper"

describe Order do
  let(:order) { Order.new }

  describe 'relations' do
    it 'has a list of order_items' do
      moon = orders(:moon)
      moon.must_respond_to :orders
      orders.order_items.each do |order|
        order.must_be_kind_of Order
      end
    end
  end


end
