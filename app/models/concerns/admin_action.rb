class AdminAction
  CALLBACK_TYPE = 'admin_action'

  def self.add_text_prompt(user)
    return unless user.check_admin

    response_types = Response.keys.keys
    buttons = response_types.each_slice(2).to_a

    TelegramClient.make_buttons(user.telegram_id,
                                'Please choose the type of message to add',
                                buttons)
  end


  def self.add_intro_question(user)
    return unless user.check_admin

    user.status_metadata['intro_question_state'] = 'question'
    user.status_metadata['previous_status'] = user.status
    user.adding_intro_question!

    TelegramClient.send_message(user.telegram_id,
                                'Please enter the question')
  end


  def self.evaluate_text(user,text)

    if user.adding_text?
      Response.create(key: user.status_metadata['editing_response'],
      text: text)
      user.restore_status
      TelegramClient.send_message(user.telegram_id,
      'Thanks for the fun message')
      return true
    end

    if user.adding_intro_question?
      districts = District.order(:id)
      if user.status_metadata['intro_question_state'] == 'question'
        question = IntroQuestion.create(text: text)
        next_district = districts.first
        user.status_metadata['intro_question_state'] = {question: question.id, district: next_district.id}
        user.save!
        TelegramClient.send_message(user.telegram_id,
                                    "Please send option for #{next_district.name} District #{next_district.symbol} now")
        return true
      end

      case user.status_metadata['intro_question_state']['district']
        when districts.first.id
          IntroQuestionOption.create!(district: districts.first,
                                      intro_question_id: user.status_metadata['intro_question_state']['question'],
                                      text: text)
          next_district = districts.second
        when districts.second.id
          IntroQuestionOption.create!(district: districts.second,
                                      intro_question_id: user.status_metadata['intro_question_state']['question'],
                                      text: text)
          next_district = districts.third
        when districts.third.id
          IntroQuestionOption.create!(district: districts.third,
                                      intro_question_id: user.status_metadata['intro_question_state']['question'],
                                      text: text)
          next_district = districts.fourth
        when districts.fourth.id
          IntroQuestionOption.create!(district: districts.fourth,
                                      intro_question_id: user.status_metadata['intro_question_state']['question'],
                                      text: text)
          next_district = districts.fifth
        when districts.fifth.id
          IntroQuestionOption.create!(district: districts.fifth,
                                      intro_question_id: user.status_metadata['intro_question_state']['question'],
                                      text: text)
          user.restore_status
          TelegramClient.send_message(user.telegram_id,
                                      'Thank you for the new question!')
          return true
      end

      user.status_metadata['intro_question_state']['district'] = next_district.id
      user.save!
      TelegramClient.send_message(user.telegram_id,
                                  "Please send option for #{next_district.name} District #{next_district.symbol} now")


      return true
    end

    response_types = Response.keys.keys
    if response_types.include?(text)
      user.status_metadata['editing_response'] = text.to_sym
      user.status_metadata['previous_status'] = user.status
      user.adding_text!
      TelegramClient.send_message(user.telegram_id,
      'Enter the text please')
      return true
    end

    false
  end

  def view_battles(user,count = 10)
    games = WwGame.order(id: :desc).limit(count)
    message = "Summary of battles:\n"
    games.each do |game|
      message << game.summary_string + "\n"
    end
    TelegramClient.send_message(user.telegram_id,
                                message)
  end
end