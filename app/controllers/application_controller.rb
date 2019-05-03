class ApplicationController < ActionController::Base
  before_action :find_user
  before_action :current_order

  def render_404
    # DPR: this will actually render a 404 page in production
    raise ActionController::RoutingError, 'Not Found'
  end

  private

  def find_user
    @login_user = Merchant.find_by(id: session[:merchant_id]) if session[:merchant_id]
  end

  def current_order
    # If a session[:merchant_id] already exists then find the Order with that id, 
    # If there is no order with that id then set the session id to nil.
    if session[:merchant_id]
      orders = Order.where(id: session[:merchant_id])
      order = orders.find_by(status: 'pending')
      if order.present?
        @current_order = order
      else
        session[:merchant_id] = nil
      end
    end

    # If there is no session[:order_id] associated with this user 
    # then create a new order and store it in the users session id
    if session[:merchant_id] == nil
      @current_order = Order.create
      session[:order_id] = @current_order.id
    end
  end
end
