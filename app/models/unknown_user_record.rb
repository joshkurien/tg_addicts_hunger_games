class UnknownUserRecord < ActiveRecord::Base
  belongs_to :game_score

  def self.names
    select(:name).distinct(:name).map(&:name)
  end

  def self.update_unknown(tg_id,user_id)
    records = where(telegram_id: tg_id)
    records.each do |record|
      score_record = record.game_score
      score_record.update!(user_id: user_id)
      record.destroy
    end
  end
end