class BarsController < ApplicationController
  helper_method :user_name, :user_name_memo

  def index
    render template: "foo/bars/index"
  end

  def user_name
    return params[:user_name]
  end

  def user_name_memo
    @user_name ||= params[:user_name]
  end

  def show
    @user_website = params[:website]
    dt = params[:text]
    @instance_text = dt
    @safe_foo = params[:text]
    @safe_foo = "safe_foo"
    @html_escaped = ERB::Util.html_escape(params[:text])
    @header_escaped = ERB::Util.html_escape(cookies[:foo]) # OK - cookies not controllable by 3rd party
    response.header["content-type"] = params[:content_type]
    response.header["x-customer-header"] = params[:bar] # OK - header not relevant to XSS
    render "foo/bars/show", locals: { display_text: dt, safe_text: "hello" }
  end

  def make_safe_html
    str = params[:user_name]
    str.html_safe

    translate("welcome", name: params[:user_name]).html_safe # NOT OK - translate preserves taint
    t("welcome", name: params[:user_name]).html_safe # NOT OK - t is an alias of translate
    t("welcome_html", name: params[:user_name]).html_safe # OK - t escapes html when key ends in _html
    I18n.t("welcome_html", name: params[:user_name]).html_safe # NOT OK - I18n.t does not escape html
    I18n.translate("welcome_html", name: params[:user_name]).html_safe # NOT OK - alias
  end
end
