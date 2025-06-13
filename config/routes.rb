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

  namespace :admin do
    get 'reservations/index'
    resources :reservations, only: [:index]
  end

  # トップページ
  root "homes#index"

  # オプションのヘルスチェック
  get "up" => "rails/health#show", as: :rails_health_check

  # 必要ならカスタムコールバックルート（DeviseのOmniauthを使ってない場合のみ）
  #get '/auth/:provider/callback', to: 'google#callback'
  #get '/auth/failure', to: redirect('/')
  get  'google_calendar',              to: 'google_calendar#index'
  get  'google_calendar/auth',         to: 'google_calendar#authorize'
  get  'google_calendar/callback',     to: 'google_calendar#callback'
  post 'google_calendar/create_event', to: 'google_calendar#create_event'
  get 'oauth2callback', to: 'google_calendar#callback'
end
