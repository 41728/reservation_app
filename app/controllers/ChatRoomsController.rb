# app/controllers/chat_rooms_controller.rb
class ChatRoomsController < ApplicationController
  before_action :authenticate_user!

  # チャットルーム一覧（ログインユーザーの参加チャットルーム）
  def index
    @chat_rooms = current_user.chat_rooms.includes(:users, messages: :user)
    
    # 各チャットルームの未読メッセージ数を取得
    @unread_counts = {}
    @chat_rooms.each do |room|
      @unread_counts[room.id] = room.messages.where(read: false).where.not(user_id: current_user.id).count
    end
  end

  # 1対1チャットルーム作成（管理者とユーザー間のみ）
  def create
    target_user = User.find(params[:user_id])
    unless current_user.admin? || target_user.admin?
      redirect_to chat_rooms_path, alert: "管理者とユーザー間のみチャット可能です"
      return
    end

    # 既存のチャットルームを探す（ユーザー2人だけのルーム）
    room = ChatRoom.joins(:users)
                   .group('chat_rooms.id')
                   .having('COUNT(chat_rooms.id) = 2')
                   .where(users: { id: [current_user.id, target_user.id] })
                   .first

    unless room
      room = ChatRoom.create!
      room.chat_room_users.create!(user: current_user)
      room.chat_room_users.create!(user: target_user)
    end

    redirect_to chat_room_path(room)
  end

  # チャットルーム詳細（メッセージ一覧）
  def show
    @chat_room = current_user.chat_rooms.find(params[:id])
    @messages = @chat_room.messages.includes(:user).order(:created_at)

    # 未読メッセージを自分の既読に更新
    @chat_room.messages.where(read: false).where.not(user_id: current_user.id).update_all(read: true)
    @message = Message.new
  end
end
