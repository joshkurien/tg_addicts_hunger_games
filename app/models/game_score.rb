class GameScore < ActiveRecord::Base
  belongs_to :ww_game
  belongs_to :user


end