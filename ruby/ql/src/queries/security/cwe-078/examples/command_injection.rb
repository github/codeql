class UsersController < ActionController::Base
  def create
    command = params[:command]
    system(command) # BAD
  end
end
