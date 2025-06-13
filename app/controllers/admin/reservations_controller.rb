# app/controllers/admin/reservations_controller.rb
class Admin::ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin

  def index
    @reservations = Reservation.includes(:user).all.order(start_time: :asc)
  end

  private

  def ensure_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "アクセス権限がありません"
    end
  end
end
