class WwGame < ActiveRecord::Base
  has_many :game_scores
  validates_uniqueness_of :game_time

 
end