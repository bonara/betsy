require "test_helper"

describe Category do
  describe 'validations' do
    it 'requires a name' do
      category = Category.new
      category.valid?.must_equal false
      category.errors.messages.must_include :name
    end
  end
  describe 'relations' do
    it 'has a list of products' do
      moon = products(:moon)
      category1 = categories(:romantic)
      category2 = categories(:adventure)
      moon.categories << category1
      moon.categories << category2
      moon.must_respond_to :categories
      moon.categories.each do |category|
        category.must_be_kind_of Category
      end

      expect(moon.categories.length).must_equal 2
      expect(category1.products.length).must_equal 1
    end
  end
end