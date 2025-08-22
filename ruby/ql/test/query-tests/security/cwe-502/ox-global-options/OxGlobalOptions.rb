require "ox"

class UsersController < ActionController::Base
  # BAD - Ox.load is unsafe when the mode :object is set globally
  def route0
    xml_data = params[:key]
    object = Ox.load xml_data
  end

  # GOOD - the unsafe mode set globally is overridden with an insecure mode passed as
  # a call argument
  def route1
    xml_data = params[:key]
    object = Ox.load xml_data, mode: :generic
  end
end
