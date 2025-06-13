class ApplicationController < ActionController::Base
  # ビューでuser_signed_in?やcurrent_userを使うための設定
  helper_method :user_signed_in?, :current_user

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # 新規登録時にnicknameを許可
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])
    # アカウント編集時にnicknameを許可
    devise_parameter_sanitizer.permit(:account_update, keys: [:nickname])
  end

   private

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == 'admin' && password == '2222'
    end
  end
end


