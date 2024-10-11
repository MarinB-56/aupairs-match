class UsersController < ApplicationController
  def index
    @aupairs = User.aupair
  end
end
