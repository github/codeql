require 'erb'
require 'slim'

class GoodController < ActionController::Base
  def some_request_handler
    name = params["name"]
    html_text = "
      <!DOCTYPE html><html><body>
      <h2>Hello <%= name %> </h2></body></html>
      "
    template = ERB.new(html_text).result(binding) 
    render inline: html_text
  end
end

class GoodController < ActionController::Base
  def some_request_handler
    name = params["name"]
    html_text = "
    <!DOCTYPE html>
      html
        body
          h2  == name;
    "
    Slim::Template.new{ html_text }.render(Object.new, name: name)
  end
end