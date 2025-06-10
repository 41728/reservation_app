Rails.application.routes.draw do
  # Deviseルートを先に定義！
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  # 通常のリソースルーティング
  resources :homes, except: [:show]
  resources :users, only: [:show]

  resources :chat_rooms, only: [:index, :show, :create] do
    resources :messages, only: [:create]
  end  # ここを追加

  # トップページ
  root "homes#index"

  # オプションのヘルスチェック
  get "up" => "rails/health#show", as: :rails_health_check
end
