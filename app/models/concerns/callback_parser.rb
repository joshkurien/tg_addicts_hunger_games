class CallbackParser
  def self.process(callback)
    user = User.get_user(callback[:message][:chat])
    begin
      TelegramClient.edit_inline_message(user.telegram_id,
                                         callback[:message][:message_id],
                                         'Thank you')
    rescue
      TelegramClient.send_message(user.telegram_id,"Calm down please")
    end

    user.intro_answer(eval(callback[:data]))
  end
end