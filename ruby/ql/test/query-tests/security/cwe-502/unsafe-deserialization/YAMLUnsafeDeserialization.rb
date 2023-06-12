require 'yaml'
class UsersController < ActionController::Base
  def example
    # safe
    Psych.load(params[:yaml_string])
    Psych.load_file(params[:yaml_file])
    Psych.parse_stream(params[:yaml_string])
    Psych.parse(params[:yaml_string])
    Psych.parse_file(params[:yaml_file])
    # unsafe
    Psych.unsafe_load(params[:yaml_string])
    Psych.unsafe_load_file(params[:yaml_file])
    Psych.load_stream(params[:yaml_string])
    parse_output = Psych.parse_stream(params[:yaml_string])
    parse_output.to_ruby
    Psych.parse(params[:yaml_string]).to_ruby
    Psych.parse_file(params[:yaml_file]).to_ruby
    parsed_yaml.children.each do |child|
      puts child.to_ruby
    end
    Psych.parse_stream(params[:yaml_string])  do |document|
      puts document.to_ruby
    end
    parsed_yaml.children.first.to_ruby
    parsed_yaml = Psych.parse_stream(params[:yaml_string])
    content = parsed_yaml.children[0].children[0].children
    parsed = parsed_yaml.to_ruby[0]
    parsed = content.to_ruby[0]
    Psych.parse(params[:yaml_string]).children[0].to_ruby
    # FP
    parsed_yaml = Psych2.parse_stream(params[:yaml_string])
    content = parsed_yaml.children[0].children[0].children
    parsed = parsed_yaml.to_ruby
    parsed = parsed_yaml.to_ruby[0]
  end
end


