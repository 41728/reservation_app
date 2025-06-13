class Home < ApplicationRecord
  belongs_to :user

  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :end_after_start
  validate :time_slot_available

  after_create :create_google_meet_event

  private

  def end_after_start
    return if end_time.blank? || start_time.blank?

    if end_time <= start_time
      errors.add(:end_time, "must be after the start time")
    end
  end

  def time_slot_available
    overlapping = Home.where.not(id: id)
                      .where("start_time < ? AND end_time > ?", end_time, start_time)
    if overlapping.exists?
      errors.add(:base, "予約時間が他の予約と重複しています")
    end
  end

  def create_google_meet_event
    return unless user.google_access_token.present? # トークンがあるか確認

    service = GoogleCalendarService.new(user.google_access_token)
    meet_url = service.create_event(
      summary: "予約: #{self.title || 'イベント'}",
      start_time: self.start_time,
      end_time: self.end_time
    )

    if meet_url.present?
      update_column(:google_meet_url, meet_url)
    else
      Rails.logger.error "Google Meet URLが作成できませんでした Home ID=#{id}"
    end
  rescue => e
    Rails.logger.error "Google Meetイベント作成中にエラー発生: #{e.message}"
  end
end
