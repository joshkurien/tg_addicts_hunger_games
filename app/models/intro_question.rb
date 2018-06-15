class IntroQuestion < ActiveRecord::Base
  has_many :intro_question_options

  REQUIRED_COUNT = 3

  def self.get_random
    offset(rand(self.count)).first
  end

  def option_buttons
    buttons = []
    intro_question_options.each do |option|
      buttons << [{text: option.text,
                   callback_data: "{question: #{self.id}, district: #{option.district_id}}"
                   }]
    end
    buttons
  end
end