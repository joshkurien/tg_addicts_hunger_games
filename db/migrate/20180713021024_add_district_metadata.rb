class AddDistrictMetadata < ActiveRecord::Migration[5.2]
  def change
    add_column :districts, :room_link, :string
    add_column :districts, :description, :string
  end
end
