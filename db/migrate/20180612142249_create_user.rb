class CreateUser < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.integer :telegram_id
      t.string :username
      t.string :first_name
      t.string :last_name
      t.boolean :is_bot
      t.string :language
      t.timestamps
    end
  end
end
