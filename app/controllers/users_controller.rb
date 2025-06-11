class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    # 予約一覧（任意で表示）
    @homes = @user.homes.order(start_time: :asc)

    # 管理者かどうか判定してチャットルームを取得
    if @user.admin?
      @chat_rooms = ChatRoom.all
    else
      @chat_rooms = @user.chat_rooms
    end

    @admin_user = User.find_by(role: 'admin')
  end
end
