class UsersController < ActionController::Base
  def example
    user = User.find_by(login: params[:login])
    if params[:authenticate]
      # BAD: decision to take sensitive action based on user-controlled data
      log_in user
      redirect_to user
    end
  end
end