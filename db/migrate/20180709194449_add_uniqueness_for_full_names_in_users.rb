class AddUniquenessForFullNamesInUsers < ActiveRecord::Migration[5.2]
  def change
    add_index :users, :full_name, unique: true
  end
end
