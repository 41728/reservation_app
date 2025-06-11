Rails.application.routes.draw do
  # Deviseルート（1回にまとめる）
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  # 通常のリソースルーティング
  resources :homes, except: [:show]
  resources :users, only: [:show]

  resources :chat_rooms, only: [:index, :show, :create] do
    resources :messages, only: [:create]
  end

  # トップページ
  root "homes#index"

  # オプションのヘルスチェック
  get "up" => "rails/health#show", as: :rails_health_check

  # 必要ならカスタムコールバックルート（DeviseのOmniauthを使ってない場合のみ）
  #get '/auth/:provider/callback', to: 'google#callback'
  #get '/auth/failure', to: redirect('/')
end
