class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @conversations = current_user.conversations.includes(:users, :messages)
    if params[:conversation_id]
      @conversation = @conversations.find(params[:conversation_id])
    else
      @conversation = @conversations.first
    end
  end
end
