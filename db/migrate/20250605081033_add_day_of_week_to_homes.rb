class AddDayOfWeekToHomes < ActiveRecord::Migration[7.1]
  def change
    add_column :homes, :day_of_week, :integer
  end
end
