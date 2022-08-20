class UsersController < ApplicationController

  # BAD: Disabling forgery protection may open the application to CSRF attacks
  skip_before_action :verify_authenticity_token

  def change_email
    user = current_user
    user.email = params[:new_email]
    user.save!
  end
end
