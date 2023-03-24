require 'logger'

class UsersController < ApplicationController
  def login
    logger = Logger.new STDOUT
    username = params[:username]

    # GOOD: log message constructed with unsanitized user input
    sanitized_username = username.gsub("\n", "")
    logger.info "attempting to login user: " + sanitized_username

    # ... login logic ...
  end
end
