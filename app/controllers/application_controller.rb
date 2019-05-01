class ApplicationController < ActionController::Base
  before_action :find_user

  def render_404
    # DPR: this will actually render a 404 page in production
    raise ActionController::RoutingError, 'Not Found'
  end

  private

  def find_user
    @login_user = Merchant.find_by(id: session[:merchant_id]) if session[:merchant_id]
  end
end
