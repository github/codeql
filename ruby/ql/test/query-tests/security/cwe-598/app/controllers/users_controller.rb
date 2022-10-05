class UsersController < ApplicationController

  def login_get
    password = params[:password] # BAD: route handler uses GET query parameters to receive sensitive data
    authenticate_user(params[:username], password)
  end

  def login_post
    password = params[:password] # GOOD: handler uses POST form parameters to receive sensitive data
    authenticate_user(params[:username], password)
  end

  def login_get_cookies
    password = cookies[:password] # GOOD: data sourced from cookies rather than (plaintext) query params
    authenticate_user(params[:username], password)
  end

  private
  def authenticate_user(username, password)
    # ... authenticate the user here
  end
end
