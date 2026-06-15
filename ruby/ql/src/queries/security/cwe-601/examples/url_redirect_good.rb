class HelloController < ActionController::Base
  VALID_REDIRECTS = [
    "http://cwe.mitre.org/data/definitions/601.html",
    "http://cwe.mitre.org/data/definitions/79.html"
  ].freeze

  def hello
    # GOOD: the request parameter is validated against a known list of URLs
    target_url = params[:url]
    if VALID_REDIRECTS.include?(target_url)
      redirect_to target_url
    else
      redirect_to "/error.html"
    end
  end
end