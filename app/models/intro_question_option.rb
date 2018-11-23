class IntroQuestionOption < ActiveRecord::Base
  belongs_to :group
  belongs_to :intro_question
end