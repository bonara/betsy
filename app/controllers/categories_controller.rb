class CategoriesController < ApplicationController
  skip_before_action :require_login, only: %i[index show]
  before_action :find_category, only: [:show, :edit, :update, :destroy]

  def index; end

  def show; end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      puts 'controller'
      flash[:status] = :success
      flash[:result_text] = "Successfully created category #{@category.name}"
      redirect_to categories_path
    else
      puts 'controller'
      flash.now[:status] = :failure
      flash[:result_text] = 'Could not create a category'
      flash[:messages] = @category.errors.messages
      render :new, status: :bad_request
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def find_category
    @category = Category.find_by(id: params[:id])
    unless @category
      head :not_found
      return
    end
  end
end
