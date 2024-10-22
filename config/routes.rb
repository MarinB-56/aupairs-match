Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root to: 'users#index', as: :authenticated_root  # Route pour les utilisateurs connectés
  end

  unauthenticated do
    root to: 'pages#home', as: :unauthenticated_root  # Route pour les utilisateurs non connectés
  end

  # Route pour la homepage
  get 'home', to: "pages#home"

  resources :users, only: [:show, :index, :edit, :update] do
    member do
      post 'add_language', to: 'users#add_language'
      delete 'remove_language/:language_id', to: 'users#remove_language', as: 'remove_language'
      delete 'remove_availability/:availability_id', to: 'users#remove_availability', as: 'remove_availability'
    end
  end

  # Pour la messagerie
  resources :conversations, only: [:index, :show, :create] do
    resources :messages, only: [:create]
  end

  patch 'users/:id/update_profile_picture', to: 'users#update_profile_picture', as: 'update_profile_picture'

  get "my_favorites", to: "favorites#index"
  get "my_matches", to: "matches#index"

  resources :favorites, only: [:create, :destroy]
  resources :matches, only: [:create, :destroy, :update]
end
