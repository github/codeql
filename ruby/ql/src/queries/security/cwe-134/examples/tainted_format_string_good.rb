class UsersController < ActionController::Base
  def index
    printf("Unauthorised access attempt by %s: %s", params[:user], request.ip)
  end
end