class User < ActiveRecord::Base
  enum status: [:created, :registered, :intro_question, :allocated]

  belongs_to :district, optional: true

  def self.get_user(from_params)
    user = find_by_telegram_id(from_params[:id].to_i)
    return user unless user.nil?

    register_user(from_params)
  end

  def intro_answer(data)
    self[:status_metadata]['intro_questions']["#{data[:question]}"] = data[:district]
    save!
    if status_metadata['intro_questions'].count < IntroQuestion::REQUIRED_COUNT
      UserFlow.intro_questions(self)
      return
    end

    allocate_district
  end

  private
  def self.register_user(info)
    User.create(username: info[:username], telegram_id: info[:id],
                first_name: info[:first_name], last_name: info[:last_name],
                is_bot: info[:is_bot], language: info[:language_code],
                status_metadata: {})
  end

  def allocate_district
    district_weights = Array.new(District.count + 1, 0)
    max_value = 0

    status_metadata['intro_questions'].each do |question, district|
      return false if district.nil?
      district_weights[district] += 1
      if district_weights[district] > max_value
        max_value = district_weights[district]
      end
    end

    highest_voted_districts = []
    district_weights.each_with_index do |votes, district|
      highest_voted_districts << district if (votes == max_value)
    end

    if highest_voted_districts.count == 1
      self.district_id = highest_voted_districts[0]
    else
      self.district_id = District.least_populated_of(highest_voted_districts)
    end

    allocated!

    TelegramClient.send_message(telegram_id, "Congrats you're in #{self.district.name} #{self.district.symbol}")
  end
end