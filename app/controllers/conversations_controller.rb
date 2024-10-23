class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation, only: [:destroy]

  def destroy
    # Trouver l'autre utilisateur dans la conversation
    other_user = @conversation.users.where.not(id: current_user.id).first

    # Supprimer les enregistrements associés si nécessaire
    @conversation.conversation_users.destroy_all
    @conversation.messages.destroy_all

    if @conversation.destroy
      # Marquer le match avec l'utilisateur comme refusé
      match = Match.find_by(initiated_by: current_user, received_by: other_user) || Match.find_by(initiated_by: other_user, received_by: current_user)
      match.update(status: "refused") if match.present?

      flash[:notice] = "Conversation supprimée avec succès"
    else
      flash[:alert] = "Erreur lors de la suppression de la conversation"
    end
    redirect_to matches_path
  end

  private

  def set_conversation
    @conversation = current_user.conversations.find(params[:id])
  end
end
