class UsersController < ActionController::Base
  # Good - create a user description, where the name is escaped
  def create_user_description (name)
    "<h2>#{ERB::Util.html_escape(name)}</h2>".html_safe
  end
end
