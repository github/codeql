require 'yaml'

class UserController < ActionController::Base
  def yaml_example
    object = YAML.unsafe_load params[:yaml]
    object = YAML.load_stream params[:yaml]
    parsed_yaml = Psych.parse_stream(params[:yaml])
    
    # to_ruby is unsafe
    parsed_yaml.children.each do |child|
      object = child.to_ruby
    end
    object = Psych.parse(params[:yaml]).to_ruby
    # ...
  end
end