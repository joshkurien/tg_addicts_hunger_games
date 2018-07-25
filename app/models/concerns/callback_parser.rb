class CallbackParser
  def self.process(callback)
    user = User.get_user(callback[:message][:chat])
    callback_data = eval(callback[:data])

    case callback_data[:type]
    when IntroQuestion::CALLBACK_TYPE
      begin
        TelegramClient.edit_inline_message(user.telegram_id,
                                           callback[:message][:message_id],
                                           'Thank you ')
      rescue
        TelegramClient.send_message(user.telegram_id, "Calm down please")
      end
      user.intro_answer(callback_data)

      when UserFlow::CAPITOL_INVITATION_CALLBACK_TYPE
        begin
          TelegramClient.edit_inline_message(user.telegram_id,
                                             callback[:message][:message_id],
                                             callback[:message][:text] + "\n\nInteresting Choice")
        rescue
          TelegramClient.send_message(user.telegram_id, "Calm down please")
        end
        UserFlow.new.capitol_invitation(callback_data)
    end
  end
end