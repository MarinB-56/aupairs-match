Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  resources :users, only: [:show, :index, :edit, :update] do
    member do
      post 'add_language', to: 'users#add_language'
      delete 'remove_language/:language_id', to: 'users#remove_language', as: 'remove_language'
    end
  end

  patch 'users/:id/update_profile_picture', to: 'users#update_profile_picture', as: 'update_profile_picture'

  get "my_favorites", to: "favorites#my_favorites"
  get "my_matches", to: "matches#my_matches"

  resources :favorites, only: [:create, :destroy]
  resources :matches, only: [:create, :destroy, :update]
end
