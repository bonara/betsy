require "test_helper"

describe Order do
  describe 'relations' do
    it 'has a list of order_items' do
      order = orders(:order_one)
      order.must_respond_to :order_items
      order.order_items.each do |order_item|
        order_item.must_be_kind_of OrderItem
      end
    end
  end

  describe 'validations on update' do
    before do 
      @order = Order.new
    end
    it "doesn't validate on create" do
      @order.valid?.must_equal true
    end
    it "returns name validation error" do
      @order.update(email: "bob@gmail.com", address: "123 1st Street, NY 10001", 
                    cc_name: "Bobby", cc_num: "1234 2222 3333 2345", cc_exp: "2019-05-01")
      @order.valid?.must_equal false
      @order.errors.messages.must_include :name
    end

    it "returns email validation error" do
      @order.update(name: "Bob", address: "123 1st Street, NY 10001", 
                    cc_name: "Bobby", cc_num: "1234 2222 3333 2345", cc_exp: "2019-05-01")
      @order.valid?.must_equal false
      @order.errors.messages.must_include :email
    end

    it "returns address validation error" do
      @order.update(name: "Bob", email: "bob@gmail.com", 
                    cc_name: "Bobby", cc_num: "1234 2222 3333 2345", cc_exp: "2019-05-01")
      @order.valid?.must_equal false
      @order.errors.messages.must_include :address
    end

    it "returns cc name validation error" do
      @order.update(name: "Bob", email: "bob@gmail.com", address: "123 1st Street, NY 10001",
                    cc_num: "1234 2222 3333 2345", cc_exp: "2019-05-01")
      @order.valid?.must_equal false
      @order.errors.messages.must_include :cc_name
    end

    it "returns cc num validation error" do
      @order.update(name: "Bob", email: "bob@gmail.com", address: "123 1st Street, NY 10001",
                    cc_name: "Bobby",cc_exp: "2019-05-01")
      @order.valid?.must_equal false
      @order.errors.messages.must_include :cc_num
    end

    it "returns cc exp validation error" do
      @order.update(name: "Bob", email: "bob@gmail.com", address: "123 1st Street, NY 10001",
                    cc_name: "Bobby", cc_num: "1234 2222 3333 2345",)
      @order.valid?.must_equal false
      @order.errors.messages.must_include :cc_exp
    end
  end

  describe 'custom method' do 
    it "returns correct sub total" do
      order = orders(:order_one)
      order.sub_total.must_equal 47997
    end
  end
end
