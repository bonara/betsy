class CategoriesController < ApplicationController
  skip_before_action :require_login, only: %i[index show]
  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
    render_404 unless @category
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:status] = :success
      flash[:result_text] = "Successfully created category #{@category.name}"
      redirect_to categories_path
    else
      flash.now[:status] = :failure
      flash[:result_text] = 'Could not create a category'
      flash[:messages] = @category.errors.messages
      render :new, status: :bad_request
    end
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
