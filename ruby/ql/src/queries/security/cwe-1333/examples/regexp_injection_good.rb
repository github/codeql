class UsersController < ActionController::Base
  def example
    # GOOD: User input is sanitized before constructing the regular expression
    regex = Regexp.new(Regex.escape(params[:key]))
  end
end