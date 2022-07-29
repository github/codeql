class FooController < ApplicationController

  def show
    something_that_might_fail()
  rescue => e
    render e.backtrace, content_type: "text/plain"
  end


  def show2
    bt = caller()
    render bt, content_type: "text/plain"
  end

end
