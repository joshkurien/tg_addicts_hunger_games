class District < ActiveRecord::Base
  has_many :intro_question_options
end