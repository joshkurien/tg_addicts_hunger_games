class TelegramClient

  def self.send_message(chat,message)
    url = "#{Figaro.env.telegram_url}/sendMessage"
    RestClient.get(url, params: {chat_id: chat, text: message})
  end

end