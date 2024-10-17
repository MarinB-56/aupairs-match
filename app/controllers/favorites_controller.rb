class FavoritesController < ApplicationController
  def create
    visited_user = User.find(params[:visited_user])
    visiting_user = User.find(params[:visiting_user])

    favorite = Favorite.where(favoriting_user_id: visiting_user.id, favorited_user_id: visited_user.id)

    if favorite.empty?
      new_fav = Favorite.new
      new_fav.favoriting_user = visiting_user
      new_fav.favorited_user = visited_user

      if new_fav.save
        redirect_to users_path
      else
        redirect_to users_path, status: :unprocessable_entity
      end
    else
      favorite.first.delete
      redirect_to users_path
    end
  end
end
