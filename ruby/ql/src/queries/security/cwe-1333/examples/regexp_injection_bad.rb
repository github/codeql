class UsersController < ActionController::Base
  def first_example
    # BAD: Unsanitized user input is used to construct a regular expression
    regex = /#{ params[:key] }/
  end

  def second_example
    # BAD: Unsanitized user input is used to construct a regular expression
    regex = Regexp.new(params[:key])
  end
end