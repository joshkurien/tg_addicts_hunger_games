class CreateIntroQuestionOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :intro_question_options do |t|
      t.string :text
      t.references :district, index: true
      t.references :intro_question, index: true
    end
  end
end
