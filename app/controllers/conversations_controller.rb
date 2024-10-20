class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @conversations = current_user.conversations
  end

  def show
    @conversation = Conversation.find(params[:id])
    @messages = @conversation.messages.order(created_at: :asc)
  end

  def create
    @conversation = Conversation.find_or_create_by!(conversation_params)
    redirect_to @conversation
  end

  private

  def conversation_params
    # Tu dois décider comment les participants sont passés ici
    params.require(:conversation).permit(user_ids: [])
  end
end
