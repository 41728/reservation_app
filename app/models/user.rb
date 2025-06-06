class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :reservations, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :chat_room_users, dependent: :destroy
  has_many :chat_rooms, through: :chat_room_users

  def admin?
    self.role == "admin"  # roleカラムが"admin"なら管理者
  end
end
