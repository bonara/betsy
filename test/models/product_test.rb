require 'test_helper'

describe Product do
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
    it 'requires a name' do
      product = Product.new(price: 123)
      product.valid?.must_equal false
      product.errors.messages.must_include :name
    end
    it 'requires a price' do
      product = Product.new(name: 'Jupiter Tour')
      product.valid?.must_equal false
      product.errors.messages.must_include :price
    end
    it 'requires a price to greater than 0' do
      product = Product.new(name: 'Jupiter Tour', price: 0)
      product.valid?.must_equal false
      product.errors.messages.must_include :price
    end

    it 'requires a unique name' do
      ada = merchants(:ada)
      name = 'test name'
      product1 = Product.new(name: name, price: 123, merchant: ada)

      # This must go through, so we use create!
      product1.save!

      product2 = Product.new(name: name, price: 1232, merchant: ada)
      result = product2.save
      result.must_equal false
      product2.errors.messages.must_include :name
    end
  end
end
