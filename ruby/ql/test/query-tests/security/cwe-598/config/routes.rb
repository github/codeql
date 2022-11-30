Rails.application.routes.draw do
  match "users/login1", to: "users#login_get_1", via: :get
  get "users/login2", to: "users#login_get_2"
  get "users/login3", to: "users#login_get_3"
  post "users/login4", to: "users#login_post"
  get "users/login5", to: "users#login_get_cookies"
end
