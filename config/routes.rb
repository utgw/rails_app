Rails.application.routes.draw do
  get '/' => 'home#top'
  
  get 'posts/index'
  get "posts/new" => "posts#new"
  get "posts/:id/edit" => "posts#edit"
  post "posts/create" => "posts#create"
  post "posts/:id/update" => "posts#update"
  post "posts/:id/delete" => "posts#delete"

  get 'users/index'
  get '/singup' => 'users#singup'
  get '/login' => 'users#login_form'
  post '/login' => 'users#login'
  # Defines the root path route ("/")
  # root "articles#index"
end
