class AddNameForGameScores < ActiveRecord::Migration[5.2]
  def change
    add_column :game_scores, :name, :string
  end
end
