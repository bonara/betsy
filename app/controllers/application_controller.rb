class ApplicationController < ActionController::Base
  # before_action :require_login
  before_action :find_user
  before_action :current_cart

  def render_404
    # DPR: this will actually render a 404 page in production
    raise ActionController::RoutingError, 'Not Found'
  end

  def current_user
    @current_user ||= Merchant.find_by(id: session[:merchant_id]) if session[:merchant_id]
  end

  def require_login
    if current_user.nil?
      flash[:error] = 'You must be logged in to view this section'
      redirect_to root_path
    end
  end

  private

  # This is a helper method that will be removed later
  def find_user
    @current_user = Merchant.find_by(id: session[:merchant_id]) if session[:merchant_id]
  end

  def current_cart
  if session[:cart_id]
    cart = Cart.find_by(:id => session[:cart_id])
    if cart.present?
      @current_cart = cart
    else
      session[:cart_id] = nil
    end
  end

  if session[:cart_id] == nil
    @current_cart = Cart.create
    session[:cart_id] = @current_cart.id
  end
end
end
