class AddRanksToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :score, :integer
    add_column :users, :rank, :integer
  end
end
