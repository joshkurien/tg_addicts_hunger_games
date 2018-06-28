class CallbackParser
  def self.process(callback)
    user = User.get_user(callback[:message][:chat])
    begin
      TelegramClient.edit_inline_message(user.telegram_id,
                                         callback[:message][:message_id],
                                         'Thank you')
    rescue
      TelegramClient.send_message(user.telegram_id, "Calm down please")
    end

    callback_data = eval(callback[:data])

    case callback_data[:type]
      when IntroQuestion::CALLBACK_TYPE
        user.intro_answer(callback_data)
    end
  end
end