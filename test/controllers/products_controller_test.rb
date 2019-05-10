require "test_helper"

describe ProductsController do

  describe 'index' do
    it 'succeeds when there are products' do
      get products_path

      must_respond_with :success
    end

    it 'succeeds when there are no products' do
      Product.all do |product|
        product.destroy
      end

      get products_path

      must_respond_with :success
    end
  end

  describe 'new' do
    it 'succeeds' do
      merchant = merchants(:grace)

      perform_login(merchant)

      get new_product_path

      must_respond_with :success
    end
  end

  describe 'show' do
    it "returns a 404 status code if the product doesn't exist" do
      merchant = Merchant.create(
        username: 'username',
        email: 'test@test.com'
      )

      perform_login(merchant)

      product_id = 122345

      get product_path(product_id)

      must_respond_with :not_found

    end

    it "works for a product that exists" do
      merchant = Merchant.create(
        username: 'username',
        email: 'test@test.com'
      )

      perform_login(merchant)

      product = Product.create!(
        name: "pending",
        price: 20,
        merchant_id: merchant.id

        )

      get "/products/#{product.id}"

      must_respond_with :success
    end
  end

  describe "edit" do
    it "succeeds for an existing product ID" do
      merchant = Merchant.create(
        username: 'username',
        email: 'test@test.com'
      )
  
      perform_login(merchant)

      product = Product.create!(
        name: "pending",
        price: 20,
        merchant_id: merchant.id
        )

      get edit_product_path(product.id)

      must_respond_with :success
    end

    it "renders 404 not_found for a bogus product ID" do
      product_id = 987736

      get edit_product_path(product_id)

      must_respond_with :not_found
    end
  end

  describe "destroy" do
    it 'deletes a product' do
      merchant = merchants(:grace)

      perform_login(merchant)

      product = Product.create!(
        name: "great trip",
        price: 20,
        merchant_id: merchant.id
        )
    
      expect(product.name).must_equal 'great trip'
      expect(product.merchant.id).must_equal merchant.id

      delete product_path(product)

      after_delete = Product.where(id: product.id)

      expect(after_delete).must_be_empty

    end

    it 'returns a 404 if the product does not exist' do
      merchant = merchants(:grace)

      perform_login(merchant)

      product_id = 14253674828790208472262

      delete product_path(product_id)

      must_respond_with :not_found

    end
  end

  describe "create" do
    it "be able to create a new product" do

      merchant = merchants(:margaret)

      perform_login(merchant)

      product_data = {
        product: {
          name: "skydiving mars",
          price: 1.5,
          description: "adventure",
          stock: 2,
          photo_url: "insertphotohere",
    
        }
      }

      post products_path, params: product_data

      product = Product.find_by(merchant_id: merchant.id)

      expect(product.name).must_equal "skydiving mars"
      expect(product.stock).must_equal 2

      must_respond_with :redirect
      must_redirect_to product_path(product)

    end

    it "sends back bad_request if no name is sent" do
      merchant = merchants(:grace)

      perform_login(merchant)

      product_data = {
        product: {
          name: "",
          price: 1.5,
          description: "adventure",
          stock: 2,
          photo_url: "insertphotohere"
        },
      }

      expect(Product.new(product_data[:product])).wont_be :valid?

      expect {
        post products_path, params: product_data
      }.wont_change "Product.count"

      must_respond_with :bad_request
    end

  end 

end
