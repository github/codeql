require 'logger'

class UsersController < ApplicationController
  def login
    logger = Logger.new STDOUT
    username = params[:username]

    # BAD: log message constructed with unsanitized user input
    logger.info "attempting to login user: " + username

    # ... login logic ...
  end
end
