class ProductsController < ApplicationController
  skip_before_action :require_login, except: [:new, :create, :destroy]
  before_action :current_user
  before_action :find_product, only: [:show, :edit, :update, :destroy]

  def root; end

  def index
    @products = Product.all
  end

  def show; end

  def edit; end

  def update
    @product.update_attributes(product_params)
    if @product.save
      flash[:status] = :success
      flash[:result_text] = "Successfully updated #{@product.id}"
      redirect_to product_path(@product)
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = 'Could not update product'
      flash.now[:messages] = @product.errors.messages
      render :edit, status: :not_found
    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params.merge(merchant_id: session[:merchant_id]))

    if @product.save
      flash[:status] = :success
      flash[:result_text] = "Successfully created product with ID #{@product.id}"
      redirect_to product_path(@product)
    else
      flash.now[:status] = :failure
      flash[:result_text] = 'Could not create a product'
      flash[:messages] = @product.errors.messages
      render :new, status: :bad_request
    end
  end

  def destroy
    @product.destroy!
    flash[:status] = :success
    flash[:result_text] = "Successfully destroyed #{@product.name}"
    redirect_to products_path
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :stock, :price, :photo_url, :status, category_ids: [])
  end

  def find_product
    @product = Product.find_by(id: params[:id])
    unless @product
      head :not_found
      return
    end
  end
end
