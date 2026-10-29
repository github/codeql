require "active_job"
require "base64"
require "json"
require "oj"
require "yaml"

class UsersController < ActionController::Base
  # BAD before psych version 4.0.0 and 
  def route1
    yaml_data = params[:key] # $ Source
    object = Psych.load yaml_data # $ Alert
    object = Psych.load_file yaml_data
  end

  # GOOD In psych version 4.0.0 and above
  def route2
    yaml_data = params[:key] # $ Source
    object = Psych.load yaml_data # $ Alert
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
    yaml_data = params[:key] # $ Source
    object = Psych.unsafe_load(yaml_data) # $ Alert
    object = Psych.unsafe_load_file(yaml_data) # $ Alert
    object = Psych.load_stream(yaml_data) # $ Alert
    parse_output = Psych.parse_stream(yaml_data)
    object = parse_output.to_ruby # $ Alert
    object = Psych.parse(yaml_data).to_ruby # $ Alert
    object = Psych.parse_file(yaml_data).to_ruby # $ Alert
    parsed_yaml = Psych.parse_stream(yaml_data)
    parsed_yaml.children.each do |child|
      object = child.to_ruby
    end
    Psych.parse_stream(yaml_data)  do |document|
      object = document.to_ruby
    end
    object = parsed_yaml.children.first.to_ruby
    content = parsed_yaml.children[0].children[0].children
    object = parsed_yaml.to_ruby[0] # $ Alert
    object = content.to_ruby[0]
    object = Psych.parse(yaml_data).children[0].to_ruby
  end

  # GOOD
  def route5
    plist_data = params[:key]
    result = Plist.parse_xml(plist_data, marshal: false)
  end

  def stdin
    object = YAML.load $stdin.read # $ Alert

    # STDIN
    object = YAML.load STDIN.gets # $ Alert

    # ARGF
    object = YAML.load ARGF.read # $ Alert

    # Kernel.gets
    object = YAML.load gets # $ Alert

    # Kernel.readlines
    object = YAML.load readlines # $ Alert
  end
end
