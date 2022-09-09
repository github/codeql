class UsersController < ApplicationController

  def login_get
    password = params[:password] # BAD: route handler uses GET query parameters to receive sensitive data
    authenticate_user(params[:username], password) # BAD: route handler uses GET query parameters to receive sensitive data
  end

  def login_post
    password = params[:password] # GOOD: handler uses POST form parameters to receive sensitive data
    authenticate_user(params[:username], password) # GOOD: handler uses POST form parameters to receive sensitive data
  end

  private
  def authenticate_user(username, password)
    # ... authenticate the user here
  end
end
