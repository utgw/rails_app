Rails.application.routes.draw do
  get "/", to: "home#top", as: "route"
  
  post "likes/:post_id/create", to: "likes#create", as: "like"
  delete "likes/:post_id/destroy", to: "likes#destroy", as: "unlike"


  get "posts/index"
  get "posts/new", to: "posts#new"
  get "posts/:id/edit", to: "posts#edit", as: "posts_edit"
  post "posts/create", to: "posts#create"
  post "posts/:id/update", to: "posts#update", as: "posts_update"
  delete "posts/:id/delete", to: "posts#destroy", as: "posts_delete"

  get "users/index"
  get "users/:id", to: "users#show", as: "users_show"
  get "users/:id/likes", to: "users#likes", as: "users_likes"
  get "users/:id/edit", to: "users#edit", as: "users_edit"
  get "signup", to: "users#signup"
  get "login", to: "users#login_form"
  get "users/:id/following", to: "users#following"
  get "users/:id/followers", to: "users#followers"
  post "users/create", to: "users#create"
  post "users/:id/update", to: "users#update"
  post "login", to: "users#login"
  post "logout", to: "users#logout"

  resources :users do
    resource :relationships, only: [:create, :destroy]
    get :follow, on: :member
    get :followers, on: :member
  end
end
