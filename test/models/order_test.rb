require "test_helper"

describe Order do
  let(:order) { Order.new }

  # it "must be valid" do
  #   value(order).must_be :valid?
  # end

  describe 'relations' do
    it 'has a list of order_items' do
      moon = orders(:moon)
      moon.must_respond_to :orders
      orders.orderitems.each do |order|
        order.must_be_kind_of Order
      end
    end
  end

  describe 'total' do
    it 'calculate total for an order' do
      
    end
  end




end
