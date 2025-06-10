class Message < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room
  has_one_attached :image

  validates :content, presence: true
end
