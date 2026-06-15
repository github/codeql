class FooController < ActionController::Base
  def bad_handler1
    check = params[:check] # $ Source
    name = params[:name]

    if check # $ Alert
      # BAD
      authenticate_user! name
    end
  end

  def bad_handler2
    # BAD
    login if params[:login] # $ Alert
    do_something_else
  end

  def bad_handler3
    # BAD. Not detected: its the last statement in the method, so it doesn't
    # match the heuristic for an action.
    login if params[:login] # $ MISSING: Alert
  end

  def bad_handler4
    p = (params[:name] == "foo") # $ Source
    # BAD
    if p # $ Alert
      verify!
    end
  end

  def good_handler
    name = params[:name]
    # Call to a sensitive action, but the guard is not derived from user input.
    if should_auth_user?
      authenticate_user! name
    end
  end
end
