require 'yaml'

class UserController < ActionController::Base
  def safe_yaml_example
    object = YAML.load params[:yaml]
    object = Psych.load_file params[:yaml]
    object = YAML.safe_load params[:yaml]
    # ...
  end
end