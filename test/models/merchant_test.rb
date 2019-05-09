require "test_helper"

describe Merchant do
  describe 'relations' do
    it 'has a list of products' do
      ada = merchants(:ada)
      ada.must_respond_to :products
      ada.products.each do |product|
        product.must_be_kind_of Product
      end
    end
  end

  describe 'validations' do
    it 'requires a username' do
      merchant = Merchant.new(email: 'test@testuser.com')
      merchant.valid?.must_equal false
      merchant.errors.messages.must_include :username
    end
    it 'requires an email address' do
      merchant = Merchant.new(username: 'testuser')
      merchant.valid?.must_equal false
      merchant.errors.messages.must_include :email
    end

    it 'requires a unique username' do
      username = 'test username'
      merchant1 = Merchant.new(username: username, email: 'merchant1@testuser.com')

      # This must go through, so we use create!
      merchant1.save!

      merchant2 = Merchant.new(username: username, email: 'merchant2@testuser.com')
      result = merchant2.save
      result.must_equal false
      merchant2.errors.messages.must_include :username
    end

    it 'requires a unique email' do
      email = 'testuser@testuser.com'
      merchant1 = Merchant.new(username: 'merchant1', email: email)

      # This must go through, so we use create!
      merchant1.save!

      merchant2 = Merchant.new(username: 'merchant2', email: email)
      result = merchant2.save
      result.must_equal false
      merchant2.errors.messages.must_include :email
    end
  end

  describe "revenue methods" do
    before do
      @merchant = merchants(:ada)
    end

    it "can calculate its total revenue" do
      revenue = @merchant.total_revenue
      expect(revenue).must_equal 48017
    end

    it "can calculate its total order for certain type of order" do
      revenue = @merchant.total("pending")
      expect(revenue).must_equal 20
    end

    it "can calculate its total number of orders" do
      number_orders = @merchant.total_orders
      expect(number_orders).must_equal 2
    end

    it "can calculate its total number of orders for certain type of order" do
      pending = @merchant.number_orders("pending")
      paid = @merchant.number_orders("paid")
      expect(pending).must_equal 1
      expect(paid).must_equal 1
    end

    it "can calculate revenue of orders when there is no order items" do
      OrderItem.destroy_all
      revenue = @merchant.total_revenue
      expect(revenue).must_equal 0
    end

    it "can calculate revenue of orders when there is no order items" do
      OrderItem.destroy_all
      number = @merchant.total_orders
      expect(number).must_equal 0
    end
  end
end
