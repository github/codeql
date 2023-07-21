class FooController < ActionController::Base  
  def some_request_handler
    # A string tainted by user input is inserted into a template 
    # (i.e a remote flow source)
    name = params[:name]

    # Template with the source (no sanitizer)
    bad_text = "
      <!DOCTYPE html><html><body>
      <h2>Hello %s </h2></body></html>
      " % name
    # BAD: renders user input
    # where text is unsanitized
    Slim::Template.new{ bad_text }.render 

    # Template with the source (no sanitizer)
    bad2_text = "
      <!DOCTYPE html><html><body>
      <h2>Hello #{name} </h2></body></html>
      " 
    # BAD: renders user input
    # where text is unsanitized
    Slim::Template.new{ bad2_text }.render 

    # Template with the source (no render)
    good_text = "
    <!DOCTYPE html>
      html
        body
          h2  == name;
    "
    # GOOD: user input is not evaluated
    Slim::Template.new{ good_text }.render(Object.new, name: name)
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
      text_bar1 = "
      <!DOCTYPE html><html><body>
      <h2>Hello else </h2></body></html>
      " 
    end
    template_bar1 = Slim::Template.new{ text_bar1 }.render 

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
    template_bar1 = Slim::Template.new{ text_bar2 }.render 
  end
end