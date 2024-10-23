Rails.application.routes.draw do
  devise_for :users

  # Routes pour les utilisateurs connectés et non connectés
  authenticated :user do
    root to: 'users#index', as: :authenticated_root
  end

  unauthenticated do
    root to: 'pages#home', as: :unauthenticated_root
  end

  # Route pour la homepage
  get 'home', to: "pages#home"

  # Routes pour les utilisateurs
  resources :users, only: [:show, :index, :edit, :update] do
    member do
      post 'add_language', to: 'users#add_language'
      delete 'remove_language/:language_id', to: 'users#remove_language', as: 'remove_language'
      delete 'remove_availability/:availability_id', to: 'users#remove_availability', as: 'remove_availability'
    end
  end

  # Route pour mettre à jour la photo de profil
  patch 'users/:id/update_profile_picture', to: 'users#update_profile_picture', as: 'update_profile_picture'

  # Routes pour les favoris
  get 'my_favorites', to: 'favorites#index'
  resources :favorites, only: [:create, :destroy]

  # ActionCable pour les messages en instantané
  mount ActionCable.server => '/cable'

  # Routes pour les matchs
  get 'my_matches', to: 'matches#index', as: :matches
  resources :matches, only: [:create, :destroy, :update]

  # Routes pour les conversations (affichage, création, suppression)
  resources :conversations, only: [:show, :destroy] do
    # Routes imbriquées pour les messages dans une conversation
    resources :messages, only: [:create]
  end
end
