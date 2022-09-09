Rails.application.routes.draw do
  match "users/login1", to: "users#login_get", via: :get
  get "users/login2", to: "users#login_get"
  post "users/login3", to: "users#login_post"
end
