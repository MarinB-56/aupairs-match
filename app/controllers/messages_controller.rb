class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation

  def create
    @message = @conversation.messages.build(message_params)
    @message.user = current_user

    if @message.save
      # Diffuser le message via ActionCable (si utilisé)
      ConversationChannel.broadcast_to(@conversation, message: render_message(@message))

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.append('messages', partial: 'messages/message', locals: { message: @message })
        end
        format.html { redirect_to matches_path(conversation_id: @conversation.id) }
      end
    else
      head :unprocessable_entity
    end
  end

  private

  def set_conversation
    @conversation = current_user.conversations.find(params[:conversation_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end

  def render_message(message)
    render_to_string(partial: 'messages/message', locals: { message: message })
  end
end
