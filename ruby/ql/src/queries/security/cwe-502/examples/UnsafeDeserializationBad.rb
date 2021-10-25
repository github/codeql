require 'json'
require 'yaml'

class UserController < ActionController::Base
  def marshal_example
    data = Base64.decode64 params[:data]
    object = Marshal.load data
    # ...
  end

  def json_example
    object = JSON.load params[:json]
    # ...
  end

  def yaml_example
    object = YAML.load params[:yaml]
    # ...
  end
end