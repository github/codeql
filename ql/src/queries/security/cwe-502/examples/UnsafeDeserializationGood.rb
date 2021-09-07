require 'json'

class UserController < ActionController::Base
  def safe_json_example
    object = JSON.parse params[:json]
    # ...
  end
end