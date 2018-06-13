class CreateResponse < ActiveRecord::Migration[5.2]
  def change
    create_table :responses do |t|
      t.integer :key, index: true
      t.string :text
    end
  end
end
