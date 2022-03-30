class UserController < ActionController::Base
  def text_bio
    # BAD -- Using string interpolation
    user = User.find_by "name = '#{params[:user_name]}'"

    # BAD -- Using string concatenation
    find_str = "name = '" + params[:user_name] + "'"
    user = User.find_by(find_str)

    # GOOD -- Using a hash to parameterize arguments
    user = User.find_by name: params[:user_name]

    render plain: user&.text_bio
  end
end
