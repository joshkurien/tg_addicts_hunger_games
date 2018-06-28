class AdminAction
  CALLBACK_TYPE = 'admin_action'

  def self.add_text_prompt(user)
    return unless user.check_admin

    response_types = Response.keys.keys
    buttons = response_types.each_slice(2).to_a

    TelegramClient.make_buttons(user.telegram_id,
                                'Please choose the type of message to add',
                                buttons)
  end

  def self.evaluate_text(user,text)
    return unless user.check_admin

    if user.adding_text?
      Response.create(key: user.status_metadata['editing_response'],
                      text: text)
      user.restore_status
      TelegramClient.send_message(user.telegram_id,
                                  'Thanks for the fun message')
      return true
    end

    response_types = Response.keys.keys
    if response_types.include?(text)
      user.status_metadata[:editing_response] = text.to_sym
      user.status_metadata[:previous_status] = user.status
      user.adding_text!
      TelegramClient.send_message(user.telegram_id,
                                  'Enter the text please')
      return true
    end

    false
  end
end