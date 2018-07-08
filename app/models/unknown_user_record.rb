class UnknownUserRecord < ActiveRecord::Base
  belongs_to :game_score

  def self.update_unknown(name,user_id)
    records = where(name: name)
    records.each do |record|
      score_record = record.game_score
      score_record.update!(user_id: user_id)
      record.destroy
    end
  end
end