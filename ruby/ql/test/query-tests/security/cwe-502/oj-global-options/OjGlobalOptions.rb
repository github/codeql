require "oj"

class UsersController < ActionController::Base
  # GOOD - Oj.load is safe when any mode other than :object is set globally
  def route0
    json_data = params[:key]
    object = Oj.load json_data
  end

  # BAD - the safe mode set globally is overridden with an unsafe mode passed as
  # a call argument
  def route1
    json_data = params[:key]
    object = Oj.load json_data, mode: :object
  end
end
