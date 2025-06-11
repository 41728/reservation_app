class AddZoomAccessTokenToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :zoom_access_token, :string
  end
end
