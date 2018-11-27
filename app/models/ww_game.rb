class WwGame < ActiveRecord::Base
  has_many :game_scores, dependent: :destroy

  validates_uniqueness_of :game_time

  def parse_game(message)
    self.game_time = Time.at message[:forward_date]

    if !self.valid?
      return false
    end
    game = message[:text].split("\n")
    self.player_count = game.shift[/\d+$/].to_i
    game_duration = game.pop
    self.duration = game_duration[/\d\d:\d\d:\d\d/]
    self.bot = message[:forward_from][:id]

    self.save!

    game.pop
    game.each_with_index do |player_stats,index|
      player = message[:entities][index * 2][:user]
      name = player[:first_name]
      name = name + ' ' + player[:last_name] if player[:last_name].present?
      tg_id = player[:id].to_i
      life_state = player_stats[/: ./].last
      win_state = player_stats.split.last

      GameScore.new.insert_record(self.id,name,life_state,win_state,tg_id)
    end

    true
  end

  def summary_string
    "🕙 #{game_time} 🕓 -> 👨‍👨‍👦‍👦 #{player_count} Players (⏳ Duration: #{duration}⏳)"
  end
end