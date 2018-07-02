class CallParser
  def self.process(message)
    user = User.get_user(message[:from])

    case message[:text]
      when '/start'
        start(user.telegram_id)
      when '/admin'
        user.admin_actions
      when Button::AGREE
        UserFlow.process_registration(message[:from],user)
      when Button::START
        UserFlow.intro_questions(user)
      when Button::ADMIN_TEXT
        AdminAction.add_text_prompt(user)
      when Button::ADMIN_DISTRICT_QUESTION
        AdminAction.add_intro_question(user)
      else
        return if AdminAction.evaluate_text(user,message[:text])
        default_response(message[:chat][:id])
    end
  end

  private
  def self.start(chat)
    TelegramClient.make_buttons(chat,
                                (Response.get_random_text(Response.keys[:welcome]) +
                                    "\nPlease dont change your Name during the event, once you have decided on a name. Please proceed"),
                                [[Button::AGREE]])
  end

  def self.default_response(chat)
    TelegramClient.send_message(chat,Response.get_random_text(Response.keys[:spam]))
  end
end