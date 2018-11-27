class AddTgIdToUnknownUserRecord < ActiveRecord::Migration[5.2]
  def change
    add_column :unknown_user_records, :telegram_id, :integer
    add_index :unknown_user_records, :telegram_id
  end
end
