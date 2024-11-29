Rails.application.routes.draw do
  root 'sessions#new'

  get '/register', to: 'users#new'
  post '/register', to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy' 

  resources :posts do
    resources :comments, only: [:create, :destroy]
  
    member do
      post :like
    end
  end

  resources :users, only: [:new, :create]
end
