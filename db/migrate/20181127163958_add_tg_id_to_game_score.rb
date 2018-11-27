class AddTgIdToGameScore < ActiveRecord::Migration[5.2]
  def change
    add_column :game_scores, :telegram_id, :integer
    add_index :game_scores, :telegram_id
  end
end
