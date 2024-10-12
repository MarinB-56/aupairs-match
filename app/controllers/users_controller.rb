class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    # Définir les utilisateurs à afficher en fonction du rôle actuel (family ou au pair)
    @users = if current_user.family?
               User.aupair
             else
               User.family
             end

    # Récupérer les bornes min et max du nombre d'enfants parmi les utilisateurs family
    @min_children = User.family.minimum(:number_of_children)
    @max_children = User.family.maximum(:number_of_children)

    # Application des filtres
    if params[:filters].present?

      # Filtre de nationalité (pour les au pairs ou les familles, selon le rôle de l'utilisateur)
      if params[:filters][:nationality].present? && params[:filters][:nationality] != ""
        @users = @users.where(nationality: params[:filters][:nationality])
      end

      # Filtre de genre (appliqué uniquement si l'utilisateur est une famille recherchant des au pairs)
      if current_user.family? && params[:filters][:gender].present? && params[:filters][:gender] != ""
        @users = @users.where(gender: params[:filters][:gender])
      end

      # Filtrer par nombre d'enfants maximum (uniquement si l'utilisateur est un au pair recherchant des familles)
      if current_user.aupair? && params[:filters][:max_number_of_children].present?
        @users = @users.where("number_of_children <= ?", params[:filters][:max_number_of_children].to_i)
      end
    end
  end
end
