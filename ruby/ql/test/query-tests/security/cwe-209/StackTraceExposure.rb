class FooController < ApplicationController

  def show
    something_that_might_fail()
  rescue => e
    render body: e.backtrace, content_type: "text/plain" # $ Alert
  end


  def show2
    bt = caller() # $ Source
    render body: bt, content_type: "text/plain" # $ Alert
  end

  def show3
    not_a_method()
  rescue NoMethodError => e
    render body: e.backtrace, content_type: "text/plain" # $ Alert
  end

end
