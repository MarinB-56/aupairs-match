class MatchesController < ApplicationController
  def index
    @pending_matches = Match.where(received_by_id: current_user.id, status: 'pending')

    # Charger les conversations de l'utilisateur
    @conversations = current_user.conversations.includes(:users, :messages)

    # Déterminer quelle conversation afficher
    if params[:conversation_id]
      @conversation = @conversations.find(params[:conversation_id])
    else
      @conversation = @conversations.first
    end
  end

  def create
    other_user = User.find(params[:received_by])

    # Si une proposition de match existe DEJA dans l'autre sens, on la récupère
    match = Match.find_or_initialize_by(initiated_by: other_user, received_by: current_user, status: "pending")

    # Si aucun match n'existe, on le crée
    if match.new_record?
      match = Match.find_or_initialize_by(initiated_by: current_user, received_by: other_user, status: "pending")
    end

    puts "////////////////"
    puts match[:status].upcase
    puts "////////////////"

    # Si il est déjà créé, on le supprime
    respond_to do |format|
      if match.persisted? && match.initiated_by == current_user
        match.delete
        format.html { redirect_to users_path }
        format.json { render json: { message: "Match retiré avec succès", status: "deleted" }, status: :ok }
      elsif match.persisted? && match.initiated_by == other_user
        match.update(status: "accepted")
        # Créer une conversation
        conversation = Conversation.create
        ConversationUser.create(conversation: conversation, user: current_user)
        ConversationUser.create(conversation: conversation, user: other_user)
        format.html { redirect_to users_path }
        format.json { render json: { message: "Demande de match acceptée", status: "accepted" }, status: :ok }
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

    if match.update(status: status)
      if status == 'accepted'
        # Créer une conversation entre les deux utilisateurs si elle n'existe pas déjà
        other_user = match.other_user(current_user)
        conversation = current_user.conversation_with(other_user) || Conversation.create
        ConversationUser.find_or_create_by(conversation: conversation, user: current_user)
        ConversationUser.find_or_create_by(conversation: conversation, user: other_user)
      end

      respond_to do |format|
        format.js   # Répondre avec un fichier JS
      end
    end
  end
end
