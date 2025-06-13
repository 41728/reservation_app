class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])

    if current_user.admin?
      @reservations = Reservation.includes(:user).order(start_time: :asc)
      # 予約があるHomeだけ取得（重複なく）
      @homes = Home.order(start_time: :asc)
      @chat_rooms = ChatRoom.all
    else
      @reservations = @user.reservations
      @homes = @user.homes.order(start_time: :asc)
      @chat_rooms = @user.chat_rooms
    end

    # 管理者ユーザー（任意で使う）
    @admin_user = User.find_by(role: 'admin')
  end

end