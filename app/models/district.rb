class District < ActiveRecord::Base
  has_many :intro_question_options
  has_many :users

  def self.least_populated_of(district_list)
    min_population = [9999,nil]

    district_list.each do |district_id|
      district = District.find(district_id)
      population = district.users.count
      if min_population[0] > population
        min_population[0] = population
        min_population[1] = district_id
      end
    end
    min_population[1]
  end

  def description_string
    "#{self.description}\nTo join your district click [#{symbol}#{self.name}#{symbol}](#{self.room_link})"
  end
end