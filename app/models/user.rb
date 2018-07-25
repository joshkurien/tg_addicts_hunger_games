class User < ActiveRecord::Base
  enum status: [:created, :registered, :intro_question, :allocated, :adding_text, :adding_intro_question, :district_description]

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
                                [[Button::ADMIN_TEXT, Button::ADMIN_DISTRICT_QUESTION],
                                 [Button::ADMIN_LAST_10_GAMES, Button::ADMIN_VIEW_MISSING_PLAYERS],
                                 [Button::ADMIN_DISTRICT_LEADERBOARD, Button::ADMIN_DISTRICT_DESC],
                                 [Button::BACK]])
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
    begin
      update(username: info[:username],
             first_name: info[:first_name], last_name: info[:last_name],
             language: info[:language_code])
      TelegramClient.send_message(telegram_id,
                                  "Hi #{full_name}, your name information has been succesfully updated")
      UnknownUserRecord.update_unknown(self.full_name, self.id)
    rescue ActiveRecord::RecordNotUnique
      TelegramClient.send_message(telegram_id,
                                  "Looks like your name is already taken")
    end

  end

  def total_score
    self.game_scores.map(&:score).sum
  end

  def view_stats
    games = self.game_scores.order(id: :desc)
    message = "Summary of your games are as follows:\n"
    games.each do |game|
      message << game.summary_string + "\n"
    end

    TelegramClient.make_buttons(self.telegram_id,
                                message,
                                Button.default_buttons,
                                false)
  end

  def view_score
    message = "So far you have amassed **#{self.total_score}** points.\nAll the best in your ventures!"
    TelegramClient.send_message(self.telegram_id,
                                message)
  end

  def view_district
    if self.district.present?
      TelegramClient.send_message(self.telegram_id,
                                  self.district.description_string,)
      return
    end
    TelegramClient.send_message(self.telegram_id,
                                'There seems to be a problem, please contact one of the admins')
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

    TelegramClient.make_buttons(telegram_id,
                                "Congrats you're in #{self.district.name} #{self.district.symbol}",
                                Button.default_buttons,
                                false)
  end

  def set_full_name
    if last_name.blank?
      self.full_name = first_name
    else
      self.full_name = first_name + ' ' + last_name
    end
  end
end