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

  def safe_oj_example
    object = Oj.load params[:yaml], { mode: :strict }
    # or
    object = Oj.safe_load params[:yaml]
    # ...
  end
end