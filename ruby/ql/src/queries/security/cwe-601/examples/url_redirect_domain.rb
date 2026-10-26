require 'uri'

class HelloController < ActionController::Base
  KNOWN_HOST = "example.org"

  def hello
    begin
      target_url = URI.parse(params[:url])

      # Redirect if the URL is either relative or on a known good host
      if !target_url.host || target_url.host == KNOWN_HOST
        redirect_to target_url.to_s
      else
        redirect_to "/error.html" # Redirect to error page if the host is not known
      end
    rescue URI::InvalidURIError
      # Handle the exception, for example, by redirecting to a safe page
      redirect_to "/error.html"
    end
  end
end