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
  # by the routes at the top of this file.
  def route9
    redirect_to params[:key]
  end

  private

  def filter_params(input_params)
    input_params.permit(:key)
  end
end

Rails.routes.draw do
  get "/r9", to: "users#route9"
end
