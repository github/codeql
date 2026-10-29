require "open-uri"

class UsersController < ActionController::Base
  def create
    filename = params[:filename]
    open(filename) # BAD

    web_page = params[:web_page]
    URI.open(web_page) # BAD - calls `Kernel.open` internally
  end
end
