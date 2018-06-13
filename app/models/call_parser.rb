class CallParser
  def self.process(message)
    case message[:text]
      when '/start'
        start(message[:chat][:id])
      else
        default_response(message[:chat][:id])
    end
  end

  private
  def self.start(chat)
    TelegramClient.send_message(chat,Response.get_random_text(Response.keys[:welcome]))
  end

  def self.default_response(chat)
    TelegramClient.send_message(chat,Response.get_random_text(Response.keys[:spam]))
  end
end