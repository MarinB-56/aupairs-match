class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
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
      # Filtrer par nationalité
      if params[:filters][:nationality].present?
        @users = @users.where(nationality: params[:filters][:nationality]) unless params[:filters][:nationality].nil?
      end

      # Filtrer par nombre d'enfants maximum
      if params[:filters][:max_number_of_children].present?
        @users = @users.where("number_of_children <= ?", params[:filters][:max_number_of_children].to_i)
      end
    end

    respond_to do |format|
      format.html
      format.js
    end
  end
end
