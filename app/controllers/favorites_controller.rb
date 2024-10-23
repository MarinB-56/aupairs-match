class FavoritesController < ApplicationController
  def create

    visited_user = User.find(params[:visited_user])
    visiting_user = User.find(params[:visiting_user])

    # Find the object or create it
    favorite = Favorite.find_or_initialize_by(favoriting_user_id: visiting_user.id, favorited_user_id: visited_user.id)

    respond_to do |format|
      if favorite.persisted?
        favorite.delete
        format.html { redirect_to users_path }
        format.json { render json: { message: "Favori retiré avec succès", status: "deleted" }, status: :ok }
      elsif favorite.save
        format.html { redirect_to users_path }
        format.json { render json: { message: "Favori ajouté avec succès", status: "added" }, status: :ok }
      else
        format.html { redirect_to users_path, status: :unprocessable_entity }
        format.json { render json: { message: "Erreur lors de la gestion du favori" }, status: :unprocessable_entity }
      end
    end
  end

  def index
    # On récupère l'utilisateur actuellement connecté
    @user = current_user
    # Récupère les utilisateurs favorisés directement via la relation
    @favorite_users = @user.favorites_given.map(&:favorited_user)
    # = @user.favorites_given.map { |favorite| favorite.favorited_user }
  end
end
