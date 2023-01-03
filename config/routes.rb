Rails.application.routes.draw do
  get "/" => "home#top"
  
  post "users/:id/likes" => "likes#like"

  get "posts/index"
  get "posts/new" => "posts#new"
  get "posts/:id/edit" => "posts#edit"
  post "posts/create" => "posts#create"
  post "posts/:id/update" => "posts#update"
  post "posts/:id/delete" => "posts#delete"

  get "users/index"
  get "users/:id" => "users#show"
  get "users/:id/edit" => "users#edit"
  get "signup" => "users#signup"
  get "login" => "users#login_form"
  post "users/create" => "users#create"
  post "users/:id/update" => "users#update"
  post "login" => "users#login"
  post "logout" => "users#logout"
  # Defines the root path route ("/")
  # root "articles#index"
end
