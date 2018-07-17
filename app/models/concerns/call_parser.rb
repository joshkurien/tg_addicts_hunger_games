class CallParser
  def self.process(message)
    user = User.get_user(message[:from])

    case message[:text]
      when '/start'
        start(user.telegram_id)
      when '/admin'
        user.admin_actions
      when '/update_info'
        user.update_self(message[:from])
      when Button::BACK
        TelegramClient.make_buttons(message[:chat][:id],
                                    Response.get_random_text(Response.keys[:back]),
                                    Button.default_buttons)
      when Button::AGREE
        UserFlow.process_registration(message[:from],user)
      when Button::START
        UserFlow.intro_questions(user)
      when Button::VIEW_STATS
        user.view_stats
      when Button::DISTRICT
        user.view_district
      when Button::ADMIN_TEXT
        AdminAction.add_text_prompt(user)
      when Button::ADMIN_DISTRICT_QUESTION
        AdminAction.add_intro_question(user)
      when Button::ADMIN_LAST_10_GAMES
        AdminAction.new.view_battles(user)
      when Button::ADMIN_DISTRICT_DESC
        AdminAction.new.district_description(user)
      else
        if user.is_admin?
          return if AdminAction.evaluate_text(user,message[:text])
        end
        default_response(message[:chat][:id])
    end
  end

  private
  def self.start(chat)
    TelegramClient.make_buttons(chat,
                                Response.get_random_text(Response.keys[:welcome]),
                                [[Button::AGREE]])
  end

  def self.default_response(chat)
    TelegramClient.send_message(chat,
                                Response.get_random_text(Response.keys[:spam]))
  end
end