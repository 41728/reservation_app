class AddGoogleMeetUrlToHomes < ActiveRecord::Migration[7.1]
  def change
    add_column :homes, :google_meet_url, :string
  end
end
