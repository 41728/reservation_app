# app/controllers/google_controller.rb

class GoogleController < ApplicationController
  def callback
    auth = request.env['omniauth.auth']
    # 例：現在ログイン中のユーザーにトークン保存
    current_user.update(
      google_access_token: auth.credentials.token,
      google_refresh_token: auth.credentials.refresh_token,
      google_token_expires_at: Time.at(auth.credentials.expires_at)
    )
    redirect_to user_path(current_user), notice: 'Google連携に成功しました'
  end
end
