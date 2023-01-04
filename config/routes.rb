Rails.application.routes.draw do
  get "/", to: "home#top"
  
  post "likes/:post_id/create_in_home", to: "likes#create_in_home", as: "likes_in_home"
  delete "likes/:post_id/destroy_in_home", to: "likes#destroy_in_home", as: "dislikes_in_home"
  post "likes/:post_id/create_in_profile", to: "likes#create_in_profile", as: "likes_in_profile"
  delete "likes/:post_id/destroy_in_profile", to: "likes#destroy_in_profile", as: "dislikes_in_profile"

  get "posts/index"
  get "posts/new", to: "posts#new"
  get "posts/:id/edit", to: "posts#edit"
  post "posts/create", to: "posts#create"
  post "posts/:id/update", to: "posts#update"
  post "posts/:id/delete", to: "posts#delete"

  get "users/index"
  get "users/:id", to: "users#show"
  get "users/:id/likes", to: "users#likes"
  get "users/:id/edit", to: "users#edit"
  get "signup", to: "users#signup"
  get "login", to: "users#login_form"
  get "users/:id/following", to: "users#following"
  get "users/:id/followers", to: "users#followers"
  post "users/create", to: "users#create"
  post "users/:id/update", to: "users#update"
  post "login", to: "users#login"
  post "logout", to: "users#logout"

  post "follow/:id/create", to: "follow#create"
  post "follow/:id/destroy", to: "follow#destroy"
  # Defines the root path route ("/")
  # root "articles#index"
end
