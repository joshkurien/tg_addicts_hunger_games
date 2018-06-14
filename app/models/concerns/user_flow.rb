class UserFlow

  def self.process_registration(message_details,user)
    return smart_alek(user.telegram_id) unless user.created?
    user.update!(first_name: message_details[:first_name],
                 last_name: message_details[:last_name],
                 username: message_details[:username],
                 status: User.statuses[:registering])
    TelegramClient.make_buttons(user.telegram_id,
                                ("Thanks you, Kindly do not change your display name for the duration of the event\nWith that, let us start our adventure!"),
                                [[Button::START]])
  end

  def self.allocate_district

  end

  private
  def self.smart_alek(chat_id)
    TelegramClient.send_message(chat_id,
                                Response.get_random_text(Response.keys[:smart_ass]))
  end
end