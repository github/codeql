class UsersController < ActionController::Base
  def index
    puts "Unauthorised access attempt by #{params[:user]}: #{request.ip}"
  end
end