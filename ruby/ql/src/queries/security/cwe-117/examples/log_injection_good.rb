require 'logger'

class UsersController < ApplicationController
  def login
    logger = Logger.new STDOUT
    username = params[:username]

    # GOOD: log message constructed with sanitized user input
    logger.info "attempting to login user: " + sanitized_username.gsub("\n", "")

    # ... login logic ...
  end
end
