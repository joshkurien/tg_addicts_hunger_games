class ModifyDurationInWwGame < ActiveRecord::Migration[5.2]
  def change
    change_column :ww_games, :duration, :string
  end
end
