require 'erb'
require 'slim'

class BadERBController < ActionController::Base
  def some_request_handler
    name = params["name"]
    html_text = "
      <!DOCTYPE html><html><body>
      <h2>Hello %s </h2></body></html>
      " % name
    template = ERB.new(html_text).result(binding) 
    render inline: html_text
  end
end

class BadSlimController < ActionController::Base
  def some_request_handler
    name = params["name"]
    html_text = "
      <!DOCTYPE html><html><body>
      <h2>Hello %s </h2></body></html>
      " % name
    Slim::Template.new{ html_text }.render 
  end
end