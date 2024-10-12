class UsersController < ApplicationController
  def index
    @aupairs = User.aupair
  end

  def show
    @aupair = User.find(params[:id])
  end
end
