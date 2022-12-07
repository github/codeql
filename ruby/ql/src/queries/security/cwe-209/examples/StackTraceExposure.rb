class UsersController < ApplicationController

  def update_bad(id)
    do_computation()
  rescue => e
    # BAD
    render body: e.backtrace, content_type: "text/plain"
  end

  def update_good(id)
    do_computation()
  rescue => e
    # GOOD
    logger.error e.backtrace
    render body: "Computation failed", content_type: "text/plain"
  end

end