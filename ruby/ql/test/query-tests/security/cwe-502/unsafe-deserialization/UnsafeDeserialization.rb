require "base64"
require "json"
require "oj"
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

  # GOOD
  def route6
    yaml_data = params[:key]
    object = YAML.safe_load yaml_data
  end

  # BAD - Oj.load is unsafe in its default :object mode
  def route7
    json_data = params[:key]
    object = Oj.load json_data
    object = Oj.load json_data, mode: :object
  end

  # GOOD - Oj.load is safe in any other mode
  def route8
    json_data = params[:key]
    # Test the different ways the options hash can be passed
    options = { allow_blank: true, mode: :rails }
    object1 = Oj.load json_data, options
    object2 = Oj.load json_data, mode: :strict
    object3 = Oj.load json_data, :allow_blank => true, :mode => :compat

    # TODO: false positive; we aren't detecting flow from `:json` to the call argument.
    more_options = { allow_blank: true }
    more_options[:mode] = :json
    object4 = Oj.load json_data, more_options
  end

  # GOOD
  def route9
    json_data = params[:key]
    object = Oj.safe_load json_data
  end
end
