Rails.application.routes.draw do
    resources :users
    resources :comments do
        get "photo", on: :member
    end
    resources :photos
    resources :posts do
        post "upvote", on: :member
    end
    resources :tags
end
