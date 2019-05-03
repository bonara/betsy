require "test_helper"

describe ProductsController do
  describe "create" do
    it "be able to create a new product" do
    skip
      product_data = {
        product: {
          name: "skydiving mars",
          price: 1.5,
          description: "adventure",
          stock: 2,
          photo_url: "insertphotohere",
    
        }
      }

      expect {
        post products_path, params: product_data
      }.must_change "Product.count", +1

  
      must_respond_with :redirect
      must_redirect_to products_path

    end

    it "sends back bad_request if no name is sent" do
    skip
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

  describe "index" do
    it "renders without crashing" do
      get products_path
      must_respond_with :ok
    end

  end

  describe "destroy" do
  end
end
