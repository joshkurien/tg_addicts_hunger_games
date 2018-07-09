class ForwardParser
  WWMODERATOR_ID = 175844556

  def self.process(message)
    if message[:forward_from][:id] == WWMODERATOR_ID
      user = User.get_user(message[:from])
      return unless user.check_admin

      if WwGame.new.parse_game(message)
        TelegramClient.send_message(user.telegram_id,
                                    'Thanks for updating the game scores')
      else
        TelegramClient.send_message(user.telegram_id,
                                    'Too slow')
      end
    else
      CallParser.process(message)
    end
  end
end