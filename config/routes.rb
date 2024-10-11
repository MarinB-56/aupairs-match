Rails.application.routes.draw do
  devise_for :users
  root to: "users#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  resources :users, only: [:show, :index]

  get "my_favorites", to: "favorites#my_favorites"
  get "my_matches", to: "matches#my_matches"

  resources :favorites, only: [:create, :destroy]
  resources :matches, only: [:create, :destroy, :update]

  # Defines the root path route ("/")
  # root "posts#index"

  # Coucou !
end
