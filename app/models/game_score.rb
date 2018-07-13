class GameScore < ActiveRecord::Base
  belongs_to :ww_game
  belongs_to :user, optional: true
  has_one :unknown_user_record, dependent: :destroy

  ALIVE = '🙂'
  # DEAD = '💀'
  WON = 'Won'
  # LOST = 'Lost'

  WIN_SCORE = 10
  LIFE_SCORE = 5

  def insert_record(game_id, username, life_stat, victory_stat)
    self.ww_game_id = game_id
    self.alive = (life_stat == ALIVE)
    self.won = (victory_stat == WON)
    self.name = username
    self.user = User.find_by_full_name(username)
    self.process_score

    self.save!
    if self.user.blank?
      UnknownUserRecord.create!(game_score: self, name: username)
    end
  end

  def process_score
    self.score = self.score + WIN_SCORE if won?
    self.score = self.score + LIFE_SCORE if alive?
  end

  def summary_string
    game = self.ww_game
    alive_string = self.alive? ? 'Alive' : 'Dead'
    win_string = self.won? ? 'Won' : 'Lost'
    "#{self.name}: #{alive_string} & #{win_string} @ #{game.game_time}"
  end
end