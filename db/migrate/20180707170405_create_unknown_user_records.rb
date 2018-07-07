class CreateUnknownUserRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :unknown_user_records do |t|
      t.references :game_score, index: true
      t.string :name
    end
  end
end
