class CreateWwGame < ActiveRecord::Migration[5.2]
  def change
    create_table :ww_games do |t|
      t.integer :bot
      t.datetime :game_time, index: { unique: true }
      t.integer :player_count
      t.time :duration
    end
  end
end
