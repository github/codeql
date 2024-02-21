require "active_job"
require "base64"
require "json"
require "oj"
require "ox"
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

  # BAD - Oj.object_load is always unsafe
  def route10
   json_data = params[:key]
   object = Oj.object_load json_data
  end

  # BAD - Ox.parse_obj is always unsafe
  def route11
   xml_data = params[:key]
   object = Ox.parse_obj xml_data
  end

  # BAD - Ox.load with :object mode is always unsafe
  def route12
    xml_data = params[:key]
    object = Ox.load xml_data, mode: :object
  end

  # GOOD - Ox.load is safe in the default mode (which is :generic) and in any other mode than :object
  def route13
    xml_data = params[:key]
    object1 = Ox.load xml_data
    object2 = Ox.load xml_data, mode: :limited
    object3 = Ox.load xml_data, mode: :hash
    object4 = Ox.load xml_data, mode: :generic
  end

  # BAD - `Hash.from_trusted_xml` will deserialize elements with the
  # `type="yaml"` attribute as YAML.
  def route14
    xml = params[:key]
    hash = Hash.from_trusted_xml(xml)
  end

  # BAD
  def route15
    yaml_data = params[:key]
    object = Psych.load yaml_data
  end

  def stdin
    object = YAML.load $stdin.read

    # STDIN
    object = YAML.load STDIN.gets

    # ARGF
    object = YAML.load ARGF.read

    # Kernel.gets
    object = YAML.load gets

    # Kernel.readlines
    object = YAML.load readlines
  end
end
