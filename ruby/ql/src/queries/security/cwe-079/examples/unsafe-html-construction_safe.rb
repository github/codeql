class UsersController < ActionController::Base
  # Good - create a user description, where the name is escaped
  def create_user_description (name)
    "<b>#{ERB::Util.html_escape(name)}</b>".html_safe
  end
end
