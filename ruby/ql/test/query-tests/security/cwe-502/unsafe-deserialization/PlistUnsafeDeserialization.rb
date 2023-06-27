require 'yaml'
class UsersController < ActionController::Base
  def example
    # not safe
    result = Plist.parse_xml(params[:yaml_string])
    result = Plist.parse_xml(params[:yaml_string], marshal: true)

    # safe
    result = Plist.parse_xml(params[:yaml_string], marshal: false)
  end
end


