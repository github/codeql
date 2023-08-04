class FooController < ActionController::Base
  def some_request_handler
    # A string tainted by user input is inserted into a template 
    # (i.e a remote flow source)
    name = params[:name]

    # Template with the source
    bad_text = "
      <!DOCTYPE html><html><body>
      <h2>Hello %s </h2></body></html>
      " % name

    # BAD: user input is evaluated
    # where name is unsanitized
    template = ERB.new(bad_text).result(binding) 

    # BAD: user input is evaluated
    # where name is unsanitized
    render inline: bad_text

    # Template with the source 
    good_text = "
      <!DOCTYPE html><html><body>
      <h2>Hello <%= name %> </h2></body></html>
      "

    # GOOD: user input is not evaluated
    template2 = ERB.new(good_text).result(binding) 

    # GOOD: user input is not evaluated
    render inline: good_text
  end
end

class BarController < ApplicationController
  def safe_paths
    name1 = params["name1"]
    # GOOD: barrier guard prevents taint flow
    if name == "admin"
      text_bar1 = "
      <!DOCTYPE html><html><body>
      <h2>Hello %s </h2></body></html>
      " % name
    else
      text = "
      <!DOCTYPE html><html><body>
      <h2>Hello else </h2></body></html>
      " 
    end
    template_bar1 = ERB.new(text_bar1).result(binding)


    name2 = params["name2"]
    # GOOD: barrier guard prevents taint flow
    name2 = if ["admin", "guest"].include? name2
      name2
    else 
      name2 = "none"
    end
    text_bar2 = "
      <!DOCTYPE html><html><body>
      <h2>Hello %s </h2></body></html>
      " % name2
    template_bar2 = ERB.new(text_bar2).result(binding)
  end
end
