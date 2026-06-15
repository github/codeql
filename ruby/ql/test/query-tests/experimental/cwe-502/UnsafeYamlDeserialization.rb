require "active_job"
require "base64"
require "json"
require "oj"
require "yaml"

class UsersController < ActionController::Base
  # BAD before psych version 4.0.0 and 
  def route1
    yaml_data = params[:key]
    object = Psych.load yaml_data
    object = Psych.load_file yaml_data
  end

  # GOOD In psych version 4.0.0 and above
  def route2
    yaml_data = params[:key]
    object = Psych.load yaml_data
    object = Psych.load_file yaml_data
  end

  # GOOD
  def route3
    yaml_data = params[:key]
    object = Psych.parse_stream(yaml_data) 
    object = Psych.parse(yaml_data)
    object = Psych.parse_file(yaml_data)
  end

  # BAD
  def route4
    yaml_data = params[:key]
    object = Psych.unsafe_load(yaml_data)
    object = Psych.unsafe_load_file(yaml_data)
    object = Psych.load_stream(yaml_data)
    parse_output = Psych.parse_stream(yaml_data)
    object = parse_output.to_ruby
    object = Psych.parse(yaml_data).to_ruby
    object = Psych.parse_file(yaml_data).to_ruby
    parsed_yaml = Psych.parse_stream(yaml_data)
    parsed_yaml.children.each do |child|
      object = child.to_ruby
    end
    Psych.parse_stream(yaml_data)  do |document|
      object = document.to_ruby
    end
    object = parsed_yaml.children.first.to_ruby
    content = parsed_yaml.children[0].children[0].children
    object = parsed_yaml.to_ruby[0]
    object = content.to_ruby[0]
    object = Psych.parse(yaml_data).children[0].to_ruby
  end

  # GOOD
  def route5
    plist_data = params[:key]
    result = Plist.parse_xml(plist_data, marshal: false)
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
