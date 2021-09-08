require "base64"
require "json"
require "yaml"

class UsersController < ActionController::Base
  # BAD
  def route0
    serialized_data = Base64.decode64 params[:key]
    object = Marshal.load serialized_data
  end

  # BAD
  def route1
    serialized_data = Base64.decode64 params[:key]
    object = Marshal.restore serialized_data
  end

  # BAD
  def route2
    json_data = params[:key]
    object = JSON.load json_data
  end

  # BAD
  def route3
    json_data = params[:key]
    object = JSON.restore json_data
  end

  # GOOD - JSON.parse is safe to use on untrusted data
  def route4
    json_data = params[:key]
    object = JSON.parse json_data
  end

  # BAD
  def route5
    yaml_data = params[:key]
    object = YAML.load yaml_data
  end
end
