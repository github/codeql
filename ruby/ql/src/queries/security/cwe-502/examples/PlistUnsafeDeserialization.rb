require 'plist'
class UsersController < ActionController::Base
  def example
    # not safe
    config = true
    result = Plist.parse_xml(params[:yaml_string])
    result = Plist.parse_xml(params[:yaml_string], marshal: config)
    result = Plist.parse_xml(params[:yaml_string], marshal: true)

    # safe
    config = false
    result = Plist.parse_xml(params[:yaml_string], marshal: false)
    result = Plist.parse_xml(params[:yaml_string], marshal: config)
  end
end


