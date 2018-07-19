class District < ActiveRecord::Base
  has_many :intro_question_options
  has_many :users

  POP_CAP_MAX_DIFFERENCE = 2
  def self.blocked
    all_districts = District.all
    smallest_district = District.find(least_populated_of(all_districts.map(&:id)))
    least_population = smallest_district.users.count
    blocked = []
    all_districts.each do |district|
      district_population = district.users.count
      if (district_population - least_population) > POP_CAP_MAX_DIFFERENCE
        blocked << district.id
      end
    end
    blocked
  end

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