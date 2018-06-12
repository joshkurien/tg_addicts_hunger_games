class CallParser
  def self.process(message)
    case message[:text]
      when '/start'
        start(message[:chat][:id])
      else
        default_response
    end
  end

  private
  def self.start(chat)
    TelegramClient.send_message(chat,'Welcome to my bot')
  end

  def self.default_response
  end
end