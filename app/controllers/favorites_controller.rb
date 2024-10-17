class FavoritesController < ApplicationController
  def create
    visited_user = User.find(params[:visited_user])
    visiting_user = User.find(params[:visiting_user])

    favorite = Favorite.new
    favorite.favoriting_user = visiting_user
    favorite.favorited_user = visited_user

    if favorite.save
      redirect_to users_path
    else
      redirect_to users_path, status: :unprocessable_entity
    end
  end
end
