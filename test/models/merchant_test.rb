require 'test_helper'

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
      it "can calculate its total order sum" do
        merchant = merchants(:ada)
        OrderItem.create(quanitity: 2)
        revenue = merchant.total_revenue
        expect(revenue).must_be_kind_of Integer
      end
    end




    


end
