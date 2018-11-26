class Group < ActiveRecord::Base
  has_many :intro_question_options
  has_many :users

  POP_CAP_MAX_DIFFERENCE = Figaro.env.pop_cap_difference.to_i
  def self.blocked
    all_groups = Group.where.not(id: 0)
    smallest_group = Group.find(least_populated_of(all_groups.map(&:id)))
    least_population = smallest_group.users.count
    blocked = []
    all_groups.each do |group|
      group_population = group.users.count
      if (group_population - least_population) > POP_CAP_MAX_DIFFERENCE
        blocked << group.id
      end
    end
    blocked
  end

  def self.least_populated_of(group_list)
    min_population = [9999,nil]

    group_list.each do |group_id|
      group = Group.find(group_id)
      population = group.users.count
      if min_population[0] > population
        min_population[0] = population
        min_population[1] = group_id
      end
    end
    min_population[1]
  end

  def leaderboard
    message = "Top Scorers for #{self.symbol} #{self.name} #{self.symbol} are:\n"

    scores = []
    users.each do |user|
      scores << {name: user.full_name, score: user.score}
    end
    scores = scores.sort_by{|record| record[:score]}.reverse

    scores.first(15).each do |score|
      message << "#{score[:name]} => #{score[:score]}\n"
    end
    message
  end

  def description_string
    "#{self.description}\nTo join your group click [#{symbol}#{self.name}#{symbol}](#{self.room_link})"
  end
end