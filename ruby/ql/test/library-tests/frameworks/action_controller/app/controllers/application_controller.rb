class ApplicationController < ActionController::Base
  before_action :log_request

  private 

  def set_user
    @user = User.find(session[:user_id])
  end

  def log_request
    Rails.logger.info("Request: #{request.method} #{request.path}")
  end
end
