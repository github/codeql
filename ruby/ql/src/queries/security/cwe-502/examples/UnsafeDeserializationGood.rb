require 'json'

class UserController < ActionController::Base
  def safe_json_example
    object = JSON.parse params[:json]
    # ...
  end

  def safe_yaml_example
    object = YAML.safe_load params[:yaml]
    # ...
  end
end