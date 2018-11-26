class AdminAction
  CALLBACK_TYPE = 'admin_action'.freeze

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


  def self.evaluate_text(user, text)

    if user.adding_text?
      Response.create(key: user.status_metadata['editing_response'],
                      text: text)
      user.restore_status
      TelegramClient.make_buttons(user.telegram_id,
                                  'Thanks for the fun message',
                                  Button.default_buttons,
                                  false)
      return true
    end

    if user.group_description?
      group = user.group
      group.description = text
      group.save
      user.restore_status
      TelegramClient.make_buttons(user.telegram_id,
                                  "#{group.symbol} Nice description, Victory to #{group.name} #{group.symbol}",
                                  Button.default_buttons,
                                  false)
      return true
    end

    if user.adding_intro_question?
      groups = Group.order(:id)
      if user.status_metadata['intro_question_state'] == 'question'
        question = IntroQuestion.create(text: text)
        next_group = groups.first
        user.status_metadata['intro_question_state'] = {question: question.id, group: next_group.id}
        user.save!
        TelegramClient.send_message(user.telegram_id,
                                    "Please send option for #{next_group.name} #{Figaro.env.group_name} #{next_group.symbol} now")
        return true
      end

      case user.status_metadata['intro_question_state']['group']
        when groups.first.id
          IntroQuestionOption.create!(group: groups.first,
                                      intro_question_id: user.status_metadata['intro_question_state']['question'],
                                      text: text)
          next_group = groups.second
        when groups.second.id
          IntroQuestionOption.create!(group: groups.second,
                                      intro_question_id: user.status_metadata['intro_question_state']['question'],
                                      text: text)
          next_group = groups.third
        when groups.third.id
          IntroQuestionOption.create!(group: groups.third,
                                      intro_question_id: user.status_metadata['intro_question_state']['question'],
                                      text: text)
          next_group = groups.fourth
        when groups.fourth.id
          IntroQuestionOption.create!(group: groups.fourth,
                                      intro_question_id: user.status_metadata['intro_question_state']['question'],
                                      text: text)
          user.restore_status
          TelegramClient.make_buttons(user.telegram_id,
                                      'Thank you for the new question!',
                                      Button.default_buttons,
                                      false)
          return true
      end

      user.status_metadata['intro_question_state']['group'] = next_group.id
      user.save!
      TelegramClient.send_message(user.telegram_id,
                                  "Please send option for #{next_group.name} Group #{next_group.symbol} now")


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

  def group_description(user)
    return unless user.check_admin
    if group.blank?
      TelegramClient.send_message(user.telegram_id,
                                  "You dont have a #{Figaro.env.group_name} you noob")
      return
    end
    user.status_metadata['previous_status'] = user.status
    user.group_description!

    TelegramClient.send_message(user.telegram_id,
                                "Please enter the new description for *your* #{Figaro.env.group_name}")
  end

  def view_battles(user, count = 10)
    games = WwGame.order(id: :desc).limit(count)
    message = "Summary of battles:\n"
    games.each do |game|
      message << game.summary_string + "\n"
    end
    TelegramClient.send_message(user.telegram_id,
                                message)
  end

  def view_group_leaderboard(user)
    return unless user.check_admin
    group = user.group
    if group.blank?
      TelegramClient.send_message(user.telegram_id,
                                  "You dont have a #{Figaro.env.group_name} you noob")
      return
    end
    TelegramClient.send_message(user.telegram_id,
                                group.leaderboard)
  end

  def view_unknown_names(user)
    name_list = UnknownUserRecord.names.each_slice(20).to_a
    name_list.each do |list|
      message = "List of unknown names so far:\n✴️ " + list.join("\n✴️ ")
      TelegramClient.send_message(user.telegram_id,
                                  message,
                                  nil)
    end
  end
end