class FavoritesController < ApplicationController
  def create
    visited_user = User.find(params[:visited_user])
    visiting_user = User.find(params[:visiting_user])

    # Find the object or create it
    favorite = Favorite.find_or_initialize_by(favoriting_user_id: visiting_user.id, favorited_user_id: visited_user.id)

    if favorite.persisted?
      favorite.delete
      redirect_to users_path
    elsif favorite.save
      redirect_to users_path
    else
      redirect_to users_path, status: :unprocessable_entity
    end
  end
end
