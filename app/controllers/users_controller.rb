class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])

    if current_user.admin?
      # 管理者は全予約・全homes表示
      @reservations = Reservation.all.includes(:user)
      @homes = Home.includes(:user).order(start_time: :asc)
      @chat_rooms = ChatRoom.all
    else
      # 一般ユーザーは自分の予約とhomes、チャットルームだけ
      @reservations = @user.reservations
      @homes = @user.homes.order(start_time: :asc)
      @chat_rooms = @user.chat_rooms
    end

    # 管理者ユーザー（任意で使う）
    @admin_user = User.find_by(role: 'admin')
  end

end
