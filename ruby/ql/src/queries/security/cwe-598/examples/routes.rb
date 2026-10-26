Rails.application.routes.draw do
  get "users/login", to: "#login_get" # BAD: sensitive data transmitted through query parameters
  post "users/login", to: "users#login_post" # GOOD: sensitive data transmitted in the request body
end
