class AddGroupMetadata < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :room_link, :string
    add_column :groups, :description, :string
  end
end
