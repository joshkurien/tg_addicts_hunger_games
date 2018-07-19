class IntroQuestion < ActiveRecord::Base
  has_many :intro_question_options

  CALLBACK_TYPE = 'intro_question'
  REQUIRED_COUNT = 3

  def self.get_random
    offset(rand(self.count)).first
  end

  def option_buttons
    buttons = []
    blocked_districts = District.blocked
    intro_question_options.order('random()').each do |option|
      next if blocked_districts.include?(option.district_id)
      buttons << [{text: option.text,
                   callback_data: "{type: '#{CALLBACK_TYPE}',question: #{self.id}, district: #{option.district_id}}"
                   }]
    end
    buttons
  end
end