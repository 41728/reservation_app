class AddDayOfWeekToHomes < ActiveRecord::Migration[7.1]
  def change
    add_column :reservations, :day_of_week, :integer
  end
end
