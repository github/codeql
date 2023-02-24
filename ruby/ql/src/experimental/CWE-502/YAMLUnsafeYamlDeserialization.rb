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

  end
end


