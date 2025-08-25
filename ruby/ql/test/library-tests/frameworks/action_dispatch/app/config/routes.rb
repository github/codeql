Rails.application.routes.draw do
  resources :posts, only: [:show, :index] do
    resources :comments do
      resources :replies, only: [:create]
      post "flag", to: :flag
    end
    post "upvote", to: "posts#upvote"
    post "downvote" => "posts#downvote"
  end

  if Rails.env.test?
    post "destroy_all_posts", to: "posts#destroy_alll"
  end

  constraints(number: /[0-9]+/) do
    get "/numbers/:number", to: "numbers#show"
  end

  scope path: "/admin" do
    get "/jobs", to: "background_jobs#index"
  end

  scope "/admin" do
    get "secrets", controller: "secrets", action: "view_secrets"
    delete ":user_id", to: "users#destroy"
  end

  match "photos/:id" => "photos#show", via: :get
  match "photos/:id", to: "photos#show", via: :get
  match "photos/:id", controller: "photos", action: "show", via: :get
  match "photos/:id", to: "photos#show", via: :all

  scope controller: "users" do
    post "upgrade", action: "start_upgrade"
  end

  scope module: "enterprise", controller: "billing" do
    get "current_billing_cycle"
  end

  resource :global_config, only: [:show]

  namespace :foo do
    resources :bar, only: [:index, :show] do
      get "show_debug", to: :show_debug
    end
  end

  scope "/users/:user" do
    delete "/notifications", to: "users/notifications#destroy", as: :user_destroy_notifications
    post "notifications/:notification_id/mark_as_read", to: "users/notifications#mark_as_read"
  end
end
