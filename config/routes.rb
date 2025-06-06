Rails.application.routes.draw do
  # Deviseルートを先に定義！
  devise_for :users

  # 通常のリソースルーティング
  resources :homes, only: [:index, :new, :show, :create]
  resources :users, only: [:show]

  resources :chat_rooms, only: [:index, :show] do
    resources :messages, only: [:create]
  end  # ここを追加

  # トップページ
  root "homes#index"

  # オプションのヘルスチェック
  get "up" => "rails/health#show", as: :rails_health_check
end
