# app/controllers/messages_controller.rb
class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @chat_room = current_user.chat_rooms.find(params[:chat_room_id])
    @message = @chat_room.messages.new(message_params)
    @message.user = current_user

    if @message.save
      ChatRoomChannel.broadcast_to(@chat_room, message: render_message(@message))
      head :ok
    else
      @messages = @chat_room.messages.includes(:user).order(:created_at)
      render 'chat_rooms/show'
    end
  end

  private

  def render_message(message)
    ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message })
  end
end
