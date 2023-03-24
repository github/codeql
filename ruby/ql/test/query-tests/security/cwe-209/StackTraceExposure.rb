class FooController < ApplicationController

  def show
    something_that_might_fail()
  rescue => e
    render body: e.backtrace, content_type: "text/plain"
  end


  def show2
    bt = caller()
    render body: bt, content_type: "text/plain"
  end

  def show3
    not_a_method()
  rescue NoMethodError => e
    render body: e.backtrace, content_type: "text/plain"
  end

end
