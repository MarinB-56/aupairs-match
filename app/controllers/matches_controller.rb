class MatchesController < ApplicationController
  def index
    received_by_user = params[:current_user]

    @pending_matches = Match.where(received_by: received_by_user, status: "pending")
    @accepted_matches = Match.where(received_by: received_by_user, status: "accepted")
    @refused_matches = Match.where(received_by: received_by_user, status: "refused")
  end

  def create
    initiator_user = User.find(params[:initiated_by])
    receiver_user = User.find(params[:received_by])

    # Si le match n'existe pas, on le crée
    match = Match.find_or_initialize_by(initiated_by: initiator_user, received_by: receiver_user, status: "pending")

    puts "////////////////"
    puts match[:status].upcase
    puts "////////////////"

    # Si il est déjà créé, on le supprime
    respond_to do |format|
      if match.persisted?
        match.delete
        format.html { redirect_to users_path }
        format.json { render json: { message: "Match retiré avec succès", status: "deleted" }, status: :ok }
      elsif match.save
        format.html { redirect_to users_path }
        format.json { render json: { message: "Match ajouté avec succès", status: "pending" }, status: :ok }
      else
        format.html { redirect_to users_path, status: :unprocessable_entity }
        format.json { render json: { message: "Erreur lors de la gestion du match" }, status: :unprocessable_entity }
      end
    end
    # Sinon, on le crée
  end

  def update
    status = params[:status]

    match = Match.find(params[:id])

    respond_to do |format|
      if  match.update(status: params[:status])
        format.json { render json: { message: "Match #{params[:status]}", status: params[:status] }, status: :ok }
      end
    end
  end
end
