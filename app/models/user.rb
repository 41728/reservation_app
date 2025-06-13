class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]


  has_many :reservations, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :chat_room_users, dependent: :destroy
  has_many :chat_rooms, through: :chat_room_users
  has_many :homes
  has_one_attached :avatar

  def admin?
    admin
  end

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_initialize
    user.email = auth.info.email
    user.password ||= Devise.friendly_token[0, 20]
    user.name = auth.info.name
    # Googleのトークンを保存
    user.google_access_token = auth.credentials.token
    user.google_refresh_token = auth.credentials.refresh_token if auth.credentials.refresh_token.present?
    user.google_token_expires_at = Time.at(auth.credentials.expires_at) if auth.credentials.expires_at.present?
    user.save(validate: false)  # バリデーション通すとメールなどで弾かれる場合があるため
    user
  end

end
