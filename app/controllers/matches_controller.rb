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
    initiator_user = User.find(params[:initiated_by])
    receiver_user = User.find(params[:received_by])

    # Si une proposition de match existe DEJA dans l'autre sens, on la récupère
    match = Match.find_or_initialize_by(initiated_by: receiver_user, received_by: initiator_user, status: "pending")

    # Si aucun match n'existe, on le crée
    if match.new_record?
      match = Match.find_or_initialize_by(initiated_by: initiator_user, received_by: receiver_user, status: "pending")
    # Si il existe déjà dans l'autre sens => Accepted
    elsif match.persisted? && match.initiated_by == receiver_user
      match.update(status: "accepted")
      # Créer une conversation
      conversation = Conversation.create
      ConversationUser.create(conversation: conversation, user: initiator_user)
      ConversationUser.create(conversation: conversation, user: receiver_user)
      format.html { redirect_to users_path }
      format.json { render json: { message: "Demande de match acceptée", status: "accepted" }, status: :ok }
    end

    puts "////////////////"
    puts match[:status].upcase
    puts "////////////////"

    # Si n'existe pas, on le crée => Pending
    # Si existe déjà dans mon sens et que la demande est "pending" => On supprime

    # Si il est déjà créé, on le supprime
    respond_to do |format|
      if match.persisted? && match.initiated_by == initiator_user
        match.delete
        format.html { redirect_to users_path }
        format.json { render json: { message: "Match retiré avec succès", status: "deleted" }, status: :ok }
      elsif match.persisted? && match.initiated_by == receiver_user
        match.update(status: "accepted")
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
