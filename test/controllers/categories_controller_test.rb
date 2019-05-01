require "test_helper"

describe CategoriesController do

  describe "create" do
    it "be able to create a new category" do
      category_data = {
        category: {
          name: "New"
        },
      }

      expect {
        post categories_path, params: category_data
      }.must_change "Category.count", +1

      must_respond_with :redirect
      must_redirect_to categories_path

    end

    it "sends back bad_request if no name is sent" do
      category_data = {
        category: {
          name: ""
        }
      }

      expect(Category.new(category_data[:category])).wont_be :valid?

      expect {
        post categories_path, params: category_data
      }.wont_change "Category.count"

      must_respond_with :bad_request
    end

  end 

  describe "index" do
    it "renders without crashing" do
      get categories_path
      must_respond_with :ok
    end

    # it "renders even if there are zero categories" do
    #   Category.destroy_all
    #   get categories_path
    #   must_respond_with :ok
    # end

  end


end
