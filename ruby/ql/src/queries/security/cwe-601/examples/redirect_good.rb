class HelloController < ActionController::Base
  VALID_REDIRECT = "http://cwe.mitre.org/data/definitions/601.html"

  def hello
    if params[:url] == VALID_REDIRECT
      redirect_to params[:url]
    else
      # error
    end
  end
end
