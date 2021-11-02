class BarsController < ApplicationController

  def index
    render template: "foo/bars/index"
  end

  def show_debug
    @user_website = params[:website]
    dt = params[:text]
    rendered = render_to_string "foo/bars/show", locals: { display_text: dt, safe_text: "hello" }
    puts rendered
    redirect_to action: "show"
  end

  def show
    @user_website = params[:website]
    dt = params[:text]
    render "foo/bars/show", locals: { display_text: dt, safe_text: "hello" }
  end
end
