class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.references :user, null: false, foreign_key: true
      t.references :chat_room, null: false, foreign_key: true
      t.text :content
      t.boolean :read, default: false, null: false

      t.timestamps
    end
  end
end
