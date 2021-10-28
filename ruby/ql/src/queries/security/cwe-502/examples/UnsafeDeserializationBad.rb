require 'json'
require 'yaml'
require 'oj'

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

  def oj_example
    object = Oj.load params[:json]
    # ...
  end
end