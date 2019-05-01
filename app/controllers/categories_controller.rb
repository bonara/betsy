class CategoriesController < ApplicationController
  def new
    @category = Category.new
  end

  def create
    category = Category.new(category_params)

    successful = category.save
    if successful
      flash[:status] = :success
      flash[:message] = "successfully saved category #{category.name}"
      redirect_to categories_path
    else
      flash.now[:status] = :error
      flash.now[:message] = "Could not save category"
      render :new, status: :bad_request
    end
  end

  def index
    @categories = Category.all
  end

  def category_params
    return params.require(:category).permit(:name)
  end


end
