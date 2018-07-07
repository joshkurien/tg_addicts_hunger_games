class CreateGameScore < ActiveRecord::Migration[5.2]
  def change
    create_table :game_scores do |t|
      t.references :ww_game, index: true
      t.references :user, index: true
      t.boolean :alive
      t.boolean :won
      t.integer :score, default: 0
    end
  end
end
