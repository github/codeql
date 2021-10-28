class StoresController < ApplicationController
  helper_method :user_handle
  def user_handle
    User.find(1).handle
  end

  def show
    dt = File.read("foo.txt")
    @instance_text = dt
    @user = User.find 1
    @safe_user_handle = ERB::Util.html_escape(@user.handle)
    @other_user_raw_name = User.find(2).raw_name
    render "foo/stores/show", locals: { display_text: dt, safe_text: "hello" }
  end
end
