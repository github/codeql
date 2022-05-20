class UsersController < ActionController::Base
  # BAD - Allow user to define code to be run.
  def create_bad
    first_name = params[:first_name]
    eval("set_name(#{first_name})")
  end

  # GOOD - Call code directly
  def create_good
    first_name = params[:first_name]
    set_name(first_name)
  end

  def set_name(name)
    @name = name
  end
end
