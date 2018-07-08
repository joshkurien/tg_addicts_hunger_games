class User < ActiveRecord::Base
  enum status: [:created, :registered, :intro_question, :allocated, :adding_text, :adding_intro_question]

  validates_presence_of :telegram_id
  belongs_to :district, optional: true
  has_many :game_scores

  before_save :set_full_name

  def self.get_user(from_params)
    user = find_by_telegram_id(from_params[:id].to_i)
    return user unless user.nil?

    register_user(from_params)
  end

  def intro_answer(data)
    self[:status_metadata]['intro_questions']["#{data[:question]}"] = data[:district]
    save!
    if status_metadata['intro_questions'].count < IntroQuestion::REQUIRED_COUNT
      UserFlow.intro_questions(self)
      return
    end

    allocate_district
  end

  def admin_actions
    return unless check_admin

    TelegramClient.make_buttons(telegram_id,
                                'Have fun Tinkering',
                                [[Button::ADMIN_TEXT],[Button::ADMIN_DISTRICT_QUESTION]])
  end

  def check_admin
    unless is_admin?
      TelegramClient.send_message(telegram_id,
                                  Response.get_random_text(:smart_ass))
      return false
    end
    true
  end

  def restore_status
    self.status = status_metadata['previous_status']
    save!
  end

  def update_self(info)
    update(username: info[:username],
           first_name: info[:first_name], last_name: info[:last_name],
           language: info[:language_code])
    TelegramClient.send_message(telegram_id,
                                "Hi #{full_name}, your name information has been succesfully updated")
    UnknownUserRecord.update_unknown(self.full_name, self.id)
  end

  private
  def self.register_user(info)
    User.create(username: info[:username], telegram_id: info[:id],
                first_name: info[:first_name], last_name: info[:last_name],
                is_bot: info[:is_bot], language: info[:language_code],
                status_metadata: {})
  end

  def allocate_district
    district_weights = Array.new(District.count + 1, 0)
    max_value = 0

    status_metadata['intro_questions'].each do |question, district|
      return false if district.nil?
      district_weights[district] += 1
      if district_weights[district] > max_value
        max_value = district_weights[district]
      end
    end

    highest_voted_districts = []
    district_weights.each_with_index do |votes, district|
      highest_voted_districts << district if (votes == max_value)
    end

    if highest_voted_districts.count == 1
      self.district_id = highest_voted_districts[0]
    else
      self.district_id = District.least_populated_of(highest_voted_districts)
    end

    allocated!

    TelegramClient.send_message(telegram_id,
                                "Congrats you're in #{self.district.name} #{self.district.symbol}")
  end

  def set_full_name
    if last_name.blank?
      self.full_name = first_name
    else
      self.full_name = first_name + ' ' + last_name
    end
  end
end