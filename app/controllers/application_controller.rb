class ApplicationController < ActionController::Base
  # ビューでuser_signed_in?やcurrent_userを使うための設定
  helper_method :user_signed_in?, :current_user
end

