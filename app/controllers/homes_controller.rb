class HomesController < ApplicationController
  before_action :authenticate_user!

  def index
    start_of_week = params[:start_date] ? Date.parse(params[:start_date]).beginning_of_week(:monday) : Date.today.beginning_of_week(:monday)
    end_of_week = start_of_week + 6.days

    @week_days = (start_of_week..end_of_week).to_a
    @homes = Home.where(start_time: start_of_week.beginning_of_day..end_of_week.end_of_day).includes(:user)
    @start_date = start_of_week
  end


  def new
    @home = Home.new
  end

  def create
    @home = current_user.homes.new(home_params)
    if @home.save
      redirect_to homes_path, notice: "予約が登録されました。"
    else
      render :new
    end
  end

  private

  def home_params
    params.require(:home).permit(:start_time, :end_time)
  end
end

