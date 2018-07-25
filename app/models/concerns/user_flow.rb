class UserFlow
  ADMIN_LIST = [159911854,255592545]
  CAPITOL_INVITATION_CALLBACK_TYPE = 'capitol_invitation'

  def self.process_registration(message_details, user)
    return smart_alek(user.telegram_id) unless user.created?
    user.update!(first_name: message_details[:first_name],
                 last_name: message_details[:last_name],
                 username: message_details[:username],
                 status: User.statuses[:registered])
    TelegramClient.make_buttons(user.telegram_id,
                                ("Thank you, If you ever change your display name. please remember to /update_info\nWith that, let us start our adventure!"),
                                [[Button::START]])
  end

  def self.intro_questions(user)

    if user.registered?
      user.status_metadata['intro_questions'] = {}
      user.status = User.statuses[:intro_question]
    end

    if user.status_metadata['intro_questions'].count == IntroQuestion::REQUIRED_COUNT
      TelegramClient.send_message(user.telegram_id,
                                  'Calm down buddy, please answer the remaining questions first')
      return
    end

    loop do
      @question = IntroQuestion.get_random
      unless user.status_metadata['intro_questions'].include?(@question.id.to_s)
        user.status_metadata['intro_questions'][@question.id] = nil
        user.save!
        break
      end
    end

    option_buttons = @question.option_buttons


    TelegramClient.make_inline_buttons(user.telegram_id,
                                       @question.text,
                                       option_buttons)
  end

  def capitol_invitation(data)
    user = User.find(data[:user_id])
    case data[:accept]
      when false
        inform_super_admins("#{user.full_name} refused to join capitol district")
      when true
        inform_super_admins("#{user.full_name} Accepted the capitol district")
        user.district = District.find(0)
        user.allocated!
        TelegramClient.send_message(user.telegram_id,
                                    'Welcome fortunate one to the capitol')
    end

  end


  def inform_super_admins(message)
    ADMIN_LIST.each do |admin_id|
      TelegramClient.send_message(admin_id,
                                  message,
                                  nil)
    end
  end

  private
  def self.smart_alek(chat_id)
    TelegramClient.make_buttons(chat_id,
                                Response.get_random_text(Response.keys[:smart_ass]),
                                Button.default_buttons,
                                false)
  end
end