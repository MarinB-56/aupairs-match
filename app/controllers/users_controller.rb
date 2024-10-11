class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    # Si l'utilisateur est une family, on affiche les au_pair, sinon on affiche les familles
    @users = if current_user.family?
               User.aupair
             else
               User.family
             end

    # Récupérer les bornes min et max du nombre d'enfants parmi les familles
    @min_children = User.family.minimum(:number_of_children)
    @max_children = User.family.maximum(:number_of_children)

    # Application des filtres
    if params[:filters].present?
      if current_user.family?
        # Filtres pour au_pair
        @users = @users.where(nationality: params[:filters][:nationality]) if params[:filters][:nationality].present?
        @users = @users.where(gender: params[:filters][:gender]) if params[:filters][:gender].present?
      else
        # Filtres pour familles
        @users = @users.where(nationality: params[:filters][:nationality]) if params[:filters][:nationality].present?

        # Filtre sur le nombre d'enfants avec un range
        if params[:filters][:min_number_of_children].present? && params[:filters][:max_number_of_children].present?
          min_children = params[:filters][:min_number_of_children].to_i
          max_children = params[:filters][:max_number_of_children].to_i
          @users = @users.where(number_of_children: min_children..max_children)
        end
      end
    end

    respond_to do |format|
      format.html
      format.js
    end
  end
end
