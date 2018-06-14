class CreateIntroQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :intro_questions do |t|
      t.string :text
    end
  end
end
