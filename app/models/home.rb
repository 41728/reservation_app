class Home < ApplicationRecord
  belongs_to :user

  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :end_after_start
  validate :time_slot_available

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
end
