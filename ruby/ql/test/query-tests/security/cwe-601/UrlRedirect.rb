class UsersController < ActionController::Base
  # BAD
  def route1
    redirect_to params
  end

  # BAD
  def route2
    redirect_to params[:key]
  end

  # BAD
  def route3
    redirect_to params.fetch(:specific_arg)
  end

  # BAD
  def route4
    redirect_to params.to_unsafe_hash
  end

  # BAD
  def route5
    redirect_to filter_params(params)
  end

  # GOOD
  def route6
    redirect_to "/foo/#{params[:key]}"
  end

  # BAD
  def route7
    redirect_to "#{params[:key]}/foo"
  end

  # GOOD
  def route8
    key = params[:key]
    if key == "foo"
      redirect_to key
    else
      redirect_to "/default"
    end
  end

  # GOOD
  # Technically vulnerable, this is a handler for a POST request,
  # so can't be triggered by following a link.
  def create1
    redirect_to params[:key]
  end

  # BAD
  # The same as `create1` but this is reachable via a GET request, as configured
  # by the routes at the bottom of this file.
  def route9
    redirect_to params[:key]
  end

  # BAD
  def route10
    redirect_back fallback_location: params[:key]
  end

  # BAD
  def route11
    redirect_back fallback_location: params[:key], allow_other_host: true
  end

  # BAD
  def route12
    redirect_back_or_to params[:key]
  end

  # GOOD
  def route13
    redirect_back fallback_location: params[:key], allow_other_host: false
  end

  # GOOD
  def route14
    redirect_back_or_to params[:key], allow_other_host: false
  end

  # GOOD
  def route15
    redirect_to cookies[:foo]
  end

  private

  def filter_params(input_params)
    input_params.permit(:key)
  end
end

Rails.routes.draw do
  get "/r9", to: "users#route9"
end

class DomainController < ActionController::Base
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

class ConstController < ActionController::Base
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