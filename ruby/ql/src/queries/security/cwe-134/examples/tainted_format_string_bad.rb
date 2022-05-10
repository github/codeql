class UsersController < ActionController::Base
  def index
    printf("Unauthorised access attempt by #{params[:user]}: %s", request.ip)
  end
end