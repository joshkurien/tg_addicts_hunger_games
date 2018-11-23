class User < ActiveRecord::Base
  enum status: [:created, :registered, :intro_question, :allocated, :adding_text, :adding_intro_question, :group_description]

  validates_presence_of :telegram_id
  belongs_to :group, optional: true
  has_many :game_scores

  before_save :set_full_name

  def self.get_user(from_params)
    user = find_by_telegram_id(from_params[:id].to_i)
    return user unless user.nil?

    register_user(from_params)
  end

  def intro_answer(data)
    self[:status_metadata]['intro_questions']["#{data[:question]}"] = data[:group]
    save!
    if status_metadata['intro_questions'].count < IntroQuestion::REQUIRED_COUNT
      UserFlow.intro_questions(self)
      return
    end

    allocate_group
  end

  def admin_actions
    return unless check_admin

    TelegramClient.make_buttons(telegram_id,
                                'Have fun Tinkering',
                                [[Button::ADMIN_TEXT, Button::ADMIN_GROUP_QUESTION],
                                 [Button::ADMIN_LAST_10_GAMES, Button::ADMIN_VIEW_MISSING_PLAYERS],
                                 [Button::ADMIN_GROUP_LEADERBOARD, Button::ADMIN_GROUP_DESC],
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
      update_score
    rescue ActiveRecord::RecordNotUnique
      TelegramClient.send_message(telegram_id,
                                  "Looks like your name is already taken")
    end

  end

  def update_score
    update(score: game_scores.map(&:score).sum)
  end

  def total_score
    score
  end

  def view_stats
    games = self.game_scores.order(id: :desc)
    message = []
    games.each do |game|
      message << game.summary_string
    end
    list = message.each_slice(25).to_a

    list.each do |set|
      TelegramClient.send_message(self.telegram_id,
                                  set.join("\n"),
                                  nil)
    end
  end

  def view_score
    message = "So far you have amassed **#{self.score}** points.\nAll the best in your ventures!"
    TelegramClient.make_buttons(self.telegram_id,
                                message,
                                Button.default_buttons,
                                false)
  end

  def view_game_count
    message = "Looks like you've played #{game_scores.count} games so far, not bad!"
    TelegramClient.make_buttons(telegram_id,
                                message,
                                Button.default_buttons,
                                false)
  end

  def view_group
    if self.group.present?
      TelegramClient.send_message(self.telegram_id,
                                  self.group.description_string)
      return
    end
    TelegramClient.send_message(self.telegram_id,
                                'There seems to be a problem, please contact one of the admins')
  end

  def update_ranks
    users = User.order(score: :desc)
    previous_score = users.first.score + 1
    previous_rank = 0
    same_rank_count = 0
    users.each do |user|
      if user.score == previous_score
        user.rank = previous_rank
        same_rank_count += 1
      else
        user.rank = previous_rank + same_rank_count + 1
        previous_rank = user.rank
        same_rank_count = 0
        previous_score = user.score
      end
      user.save
    end
  end

  def view_leaderboard(count = 30)
    users = User.order(:rank)
    position = users.find_index(self)

    message = 'Leaderboard for this event is as follows:'
    users.first(count).each do |user|
      message << "\n\##{user.rank} #{user.full_name} -> #{user.score}"
    end
    if position >= count
      position -= 1
      message << "\n.\n.\n."
      3.times do
        message << "\n\##{users[position].rank} #{users[position].full_name} -> #{users[position].score}"
        position += 1
      end
    end

    TelegramClient.make_buttons(telegram_id,
                                message,
                                Button.default_buttons,
                                false)
  end

  private
  def self.register_user(info)
    user = User.create(username: info[:username], telegram_id: info[:id],
                first_name: info[:first_name], last_name: info[:last_name],
                is_bot: info[:is_bot], language: info[:language_code],
                status_metadata: {})
    user.update_score
  end

  def allocate_group
    group_weights = Array.new(Group.count + 1, 0)
    max_value = 0

    status_metadata['intro_questions'].each do |question, group|
      return false if group.nil?
      group_weights[group] += 1
      if group_weights[group] > max_value
        max_value = group_weights[group]
      end
    end

    highest_voted_groups = []
    group_weights.each_with_index do |votes, group|
      highest_voted_groups << group if (votes == max_value)
    end

    if highest_voted_groups.count == 1
      self.group_id = highest_voted_groups[0]
    else
      self.group_id = Group.least_populated_of(highest_voted_groups)
    end

    allocated!

    TelegramClient.make_buttons(telegram_id,
                                "Congrats you're in #{self.group.name} #{self.group.symbol}",
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