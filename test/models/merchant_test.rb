require "test_helper"

describe Merchant do
  # describe 'relations' do
  #   it 'has a list of products' do
  #     ada = merchants(:ada)
  #     ada.must_respond_to :products
  #     ada.products.each do |product|
  #       product.must_be_kind_of Product
  #     end
  #   end
  # end

  # describe 'validations' do
  #   it 'requires a username' do
  #     merchant = Merchant.new(email: 'test@testuser.com')
  #     merchant.valid?.must_equal false
  #     merchant.errors.messages.must_include :username
  #   end
  #   it 'requires an email address' do
  #     merchant = Merchant.new(username: 'testuser')
  #     merchant.valid?.must_equal false
  #     merchant.errors.messages.must_include :email
  #   end

  #   it 'requires a unique username' do
  #     username = 'test username'
  #     merchant1 = Merchant.new(username: username, email: 'merchant1@testuser.com')

  #     # This must go through, so we use create!
  #     merchant1.save!

  #     merchant2 = Merchant.new(username: username, email: 'merchant2@testuser.com')
  #     result = merchant2.save
  #     result.must_equal false
  #     merchant2.errors.messages.must_include :username
  #   end

  #   it 'requires a unique email' do
  #     email = 'testuser@testuser.com'
  #     merchant1 = Merchant.new(username: 'merchant1', email: email)

  #     # This must go through, so we use create!
  #     merchant1.save!

  #     merchant2 = Merchant.new(username: 'merchant2', email: email)
  #     result = merchant2.save
  #     result.must_equal false
  #     merchant2.errors.messages.must_include :email
  #   end

  describe "revenue methods" do
    before do
      @merchant = merchants(:ada)
      @order1 = Order.create(status: "pending")
      @order2 = Order.create(status: "pending")
      @oi1 = OrderItem.create(quantity: 2, product_id: products(:rings).id, order_id: @order1.id)
      @oi2 = OrderItem.create(quantity: 3, product_id: products(:rings).id, order_id: @order2.id)
    end

    it "can calculate its total order sum" do
      revenue = @merchant.total_revenue
      sum = @oi1.quantity * @oi1.product.price + @oi2.quantity * @oi2.product.price #50
      expect(revenue).must_equal sum
    end

  end
end
