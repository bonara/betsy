require "test_helper"

describe OrderItem do
  let(:order_item) { OrderItem.new }

  it "must be valid" do
    value(order_item).must_be :valid?
  end

  describe "total" do
    it "can calculate total for an order item" do
    end
  end


end
