class TelegramClient

  def self.send_message(chat,message)
    url = "#{Figaro.env.telegram_base_url}/sendMessage"
    RestClient.post(url, {chat_id: chat, text: message})
  end

  def self.make_buttons(chat,message,buttons, one_time = true, resize=true)
    url = "#{Figaro.env.telegram_base_url}/sendMessage"
    RestClient.post(url, {chat_id: chat, text: message, reply_markup: {keyboard: buttons,
                                                                       resize_keyboard: resize,
                                                                       one_time_keyboard: one_time}.to_json})
  end

  def self.make_inline_buttons(chat,message,buttons)
    url = "#{Figaro.env.telegram_base_url}/sendMessage"
    RestClient.post(url, {chat_id: chat, text: message, reply_markup: {inline_keyboard: buttons}.to_json})
  end

  def self.edit_inline_message(chat_id,message_id ,message)
    url = "#{Figaro.env.telegram_base_url}/editMessageText"
    RestClient.post(url, {chat_id: chat_id,message_id: message_id, text: message})
  end
end