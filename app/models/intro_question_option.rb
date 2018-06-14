class IntroQuestionOption < ActiveRecord::Base
  belongs_to :district
  belongs_to :intro_question
end