class AddZoomUrlToHomes < ActiveRecord::Migration[7.1]
  def change
    add_column :homes, :zoom_url, :string
  end
end
