class CreateHomes < ActiveRecord::Migration[7.0]
  def change
    create_table :homes do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false

      t.timestamps
    end
  end
end
