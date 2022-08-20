require "excon"
require "json"

class PostsController < ActionController::Base
  def create
    user = params[:user_id]

    # BAD - user can control the entire URL of the request
    users_service_domain = params[:users_service_domain]
    response = Excon.post("#{users_service_domain}/logins", body: {user_id: user}).body
    token = JSON.parse(response)["token"]

    # GOOD - path is validated against a known fixed string
    path = if params[:users_service_path] == "v1/users"
             "v1/users"
           else 
             "v2/users"
           end
    response = Excon.post("users-service/#{path}", body: {user_id: user}).body
    token = JSON.parse(response)["token"]

    @post = Post.create(params[:post].merge(user_token: token))
    render @post
  end
end
