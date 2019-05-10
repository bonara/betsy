require "test_helper"

describe CategoriesController do

  describe 'index' do
    it 'succeeds when there are categories' do
      get categories_path

      must_respond_with :success
    end

    it 'succeeds when there are no categories' do
      Category.all do |category|
        Category.destroy
      end

      get categories_path

      must_respond_with :success
    end
  end

  describe 'new' do
    it 'succeeds' do
      merchant = merchants(:grace)

      perform_login(merchant)

      get new_category_path

      must_respond_with :success
    end
  end

  describe 'show' do
    it "returns a 404 status code if the category doesn't exist" do
      category_id = 122345

      get category_path(category_id)

      must_respond_with :not_found

    end

    it "works for a category that exists" do

      category = Category.create!(
        name: "Extreme",
        )

      get "/categories/#{category.id}"

      must_respond_with :success
    end
  end

  describe "create" do
    it "be able to create a new category for logged in user" do
      merchant = merchants(:grace)

      perform_login(merchant)

      category_data = {
        category: {
          name: "Wild West"
        },
      }

      post categories_path, params: category_data

      category = Category.last

      expect(category.name).must_equal "Wild West"

      must_respond_with :redirect
      must_redirect_to categories_path

    end

    it "Cannot create a new category if NOT logged in" do

      category_data = {
        category: {
          name: "Wild West"
        },
      }

      post categories_path, params: category_data

      must_respond_with :redirect
      must_redirect_to root_path

    end

    it "sends back bad_request if no name is sent" do
      merchant = merchants(:grace)

      perform_login(merchant)

      category_data = {
        category: {
          name: ""
        },
      }

      post categories_path, params: category_data

      expect(Category.new(category_data[:category])).wont_be :valid?

      expect {
        post categories_path, params: category_data
      }.wont_change "Category.count"

      must_respond_with :bad_request
    end

  end 

end
