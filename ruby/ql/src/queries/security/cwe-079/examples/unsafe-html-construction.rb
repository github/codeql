class UsersController < ActionController::Base
  # BAD - create a user description, where the name is not escaped
  def create_user_description (name)
    "<h2>#{name}</h2>".html_safe
  end
end
