class TelegramClient

  def self.send_message(chat,message)
    url = "#{Figaro.env.telegram_base_url}/sendMessage"
    RestClient.post(url, {chat_id: chat, text: message})
  end

  def self.make_buttons(chat,message,buttons)
    url = "#{Figaro.env.telegram_base_url}/sendMessage"
    RestClient.post(url, {chat_id: chat, text: message, reply_markup: {keyboard: buttons}.to_json})
  end
end