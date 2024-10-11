class UsersController < ApplicationController
  def index
    @roles = User.roles.keys
    @aupairs = User.aupair

    if params[:role].present?
      @selected_role = params[:role]
      @users = User.where(role: params[:role])
    else
      @selected_role = nil
      @users = User.all
    end

    respond_to do |format|
      format.html
      format.js
    end

  end
end
