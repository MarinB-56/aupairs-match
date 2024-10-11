class UsersController < ApplicationController
  before_action :authenticate_user! # Assure que seul un utilisateur connecté accède à l'index

  def index
    @roles = User.roles.keys
    @users = if current_user.aupair?
               User.family # Si l'utilisateur est au_pair, on affiche les familles
             else
               User.aupair # Sinon, on affiche les au_pairs
             end

    # Si un paramètre de rôle est passé dans l'URL, on filtre par ce rôle
    if params[:role].present?
      @users = @users.where(role: params[:role])
    end

    respond_to do |format|
      format.html
      format.js
    end
  end
end
