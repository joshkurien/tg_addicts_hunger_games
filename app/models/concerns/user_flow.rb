class UserFlow

  def self.process_registration(message_details, user)
    return smart_alek(user.telegram_id) unless user.created?
    user.update!(first_name: message_details[:first_name],
                 last_name: message_details[:last_name],
                 username: message_details[:username],
                 status: User.statuses[:registered])
    TelegramClient.make_buttons(user.telegram_id,
                                ("Thank you, If you ever change your display name. please remember to /update_info\nWith that, let us start our adventure!"),
                                [[Button::START]])
  end

  def self.intro_questions(user)

    if user.registered?
      user.status_metadata['intro_questions'] = {}
      user.status = User.statuses[:intro_question]
    end

    if user.status_metadata['intro_questions'].count == IntroQuestion::REQUIRED_COUNT
      TelegramClient.send_message(user.telegram_id,
                                  'Calm down buddy, please answer the remaining questions first')
      return
    end

    loop do
      @question = IntroQuestion.get_random
      unless user.status_metadata['intro_questions'].include?(@question.id.to_s)
        user.status_metadata['intro_questions'][@question.id] = nil
        user.save!
        break
      end
    end

    option_buttons = @question.option_buttons


    TelegramClient.make_inline_buttons(user.telegram_id,
                                       @question.text,
                                       option_buttons)
  end

  private
  def self.smart_alek(chat_id)
    TelegramClient.send_message(chat_id,
                                Response.get_random_text(Response.keys[:smart_ass]))
  end
end