class UsersController < ActionController::Base
  def login_get
    password = params[:password]
    authenticate_user(params[:username], password)
  end

  def login_post
    password = params[:password]
    authenticate_user(params[:username], password)
  end

  private
  def authenticate_user(username, password)
    # ... authenticate the user here
  end
end
