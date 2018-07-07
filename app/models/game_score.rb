class GameScore < ActiveRecord::Base
  belongs_to :ww_game
  belongs_to :user, optional: true
  has_one :unknown_user_record

  ALIVE = '🙂'
  # DEAD = '💀'
  WON = 'Won'
  # LOST = 'Lost'

  def insert_record(game_id, username, life_stat, victory_stat)
    self.ww_game_id = game_id
    self.alive = (life_stat == ALIVE)
    self.won = (victory_stat == WON)
    self.user = User.find_by_first_name(username)

    self.save!
    if self.user.blank?
      binding.pry
      UnknownUserRecord.create!(game_score: self, name: username)
    end
  end

end