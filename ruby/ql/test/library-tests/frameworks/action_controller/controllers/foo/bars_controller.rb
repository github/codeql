require 'json'

class BarsController < ApplicationController

  def index
    render template: "foo/bars/index"
  end

  def show_debug
    user_info = JSON.load cookies[:user_info]
    puts "User: #{user_info['name']}"

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
  
  def go_back
    redirect_back_or_to action: "index"
  end

  def go_back_2
    redirect_back fallback_location: { action: "index" }
  end

  def show_2
    render json: { some: "data" }
    body = render_to_string @user, content_type: "application/json"
  rescue => e
    render e.backtrace, content_type: "text/plain"
  end

  private

  def unreachable_action
    render "show"
  end
end
