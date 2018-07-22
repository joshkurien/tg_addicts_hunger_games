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
    game.each do |player_stats|
      name = player_stats[/.*:/].chomp(':')
      life_state = player_stats[/: ./].last
      win_state = player_stats.split.last

      GameScore.new.insert_record(self.id,name,life_state,win_state)
    end

    true
  end

  def summary_string
    "🕙 #{game_time} 🕓 -> 👨‍👨‍👦‍👦 #{player_count} Players (⏳ Duration: #{duration}⏳)"
  end
end