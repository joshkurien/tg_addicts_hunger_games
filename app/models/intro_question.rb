class IntroQuestion < ActiveRecord::Base
  has_many :intro_question_options

  CALLBACK_TYPE = 'intro_question'
  REQUIRED_COUNT = 3

  def self.get_random
    offset(rand(self.count)).first
  end

  def option_buttons
    buttons = []
    blocked_groups = Group.blocked
    intro_question_options.order('random()').each do |option|
      next if blocked_groups.include?(option.group_id)
      buttons << [{text: option.text,
                   callback_data: "{type: '#{CALLBACK_TYPE}',question: #{self.id}, group: #{option.group_id}}"
                   }]
    end
    buttons
  end
end