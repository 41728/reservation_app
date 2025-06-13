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
    if params[:start_time].present?
      @home = current_user.homes.new(start_time: params[:start_time])
    else
      @home = current_user.homes.new
    end
  end

  def create
    @home = current_user.homes.new(home_params)

    if @home.start_time.present?
      @home.start_time = Time.zone.parse(@home.start_time.to_s)
    end

    if @home.start_time.present? && @home.end_time.blank?
      @home.end_time = @home.start_time + 30.minutes
    end

    if @home.save
      service = GoogleService.new(current_user)
      meet_url = service.create_google_meet_event(
        summary: "予約セッション",
        start_time: @home.start_time,
        end_time: @home.end_time
      )
      @home.update(google_meet_url: meet_url)

      redirect_to user_path(current_user), notice: "予約が登録されました（Google Meetリンクあり）"
    else
      render :new
    end
  end

  def edit
    @home = current_user.homes.find(params[:id])
  end

  def update
    @home = current_user.homes.find(params[:id])
    if @home.update(home_params)
      redirect_to user_path(current_user), notice: "予約を更新しました。"
    else
      render :edit
    end
  end

  def destroy
     if current_user.admin?
      @home = Home.find(params[:id])  # 管理者は全ホームから検索
    else
      @home = current_user.homes.find(params[:id])  # 一般ユーザーは自分のもののみ
    end
    
    @home.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to user_path(current_user), notice: "予約を削除しました。" }
    end
  end

  private

  def home_params
    params.require(:home).permit(:start_time, :end_time)
  end
end
