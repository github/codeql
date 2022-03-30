class UsersController < ActionController::Base
  def create
    filename = params[:filename]
    open(filename) # BAD
  end
end  