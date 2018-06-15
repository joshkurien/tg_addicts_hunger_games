class AddDistrictToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :district, foreign_key: true
  end
end
