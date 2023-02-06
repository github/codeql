class UsersController < ApplicationController

  def login_get_1
    foo = params[:password] # BAD: route handler uses GET query parameters to receive sensitive data
    authenticate_user(params[:username], foo)
  end

  def login_get_2
    password = params[:foo] # BAD: route handler uses GET query parameters to receive sensitive data
    authenticate_user(params[:username], password)
  end

  def login_get_3
    @password = params[:foo] # BAD: route handler uses GET query parameters to receive sensitive data
    authenticate_user(params[:username], @password)
  end

  def login_post
    foo = params[:password] # GOOD: handler uses POST form parameters to receive sensitive data
    authenticate_user(params[:username], foo)
  end

  def login_get_cookies
    foo = cookies[:password] # GOOD: data sourced from cookies rather than (plaintext) query params
    authenticate_user(params[:username], foo)
  end

  private
  def authenticate_user(username, password)
    # ... authenticate the user here
  end
end
