class UsersController < ApplicationController

  def update_bad(id)
    do_computation()
  rescue => e
    # BAD
    render e.backtrace, content_type: "text/plain"
  end

  def update_good(id)
    do_computation()
  rescue => e
    # GOOD
    log e.backtrace
    redner "Computation failed", content_type: "text/plain"
  end

end