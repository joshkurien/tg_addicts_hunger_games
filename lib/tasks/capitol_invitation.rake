namespace :notify do
  desc 'Rake task to invite player to capitol'
  task :capitol_invitation, [:user_tg_id] => :environment do |t,args|
    user = User.find_by_telegram_id(args[:user_tg_id])

    district_substitution =case user.district
                              when District.find(1)
                                'Working at the docks'
                              when District.find(2)
                                'Working at the mines'
                              when District.find(3)
                                'Working at the power plant'
                              when District.find(4)
                                'Hunting'
                              when District.find(5)
                                'Working in your office'
                            end
    message = "👀....*A shadowy figure 👤, approaches you as your return home from "\
    " a hard day #{district_substitution}." \
    "\n\n*Pssst....💭\n\"We need to talk...the Capitol 👑, has noticed your skills..."\
    " it is important for the peace of Panem that the Districts be kept in their place,"\
    " reminded they must stay subservient to the Capitol 👑.\"\n\n🔊" \
    "You are being given a great opportunity of a lifetime! - you will be moved to the Capitol District 👑,"\
    "allowed to fight for us, and keep the other districts in line.  Will you join us?\n\n" \
    "🔰You will receive 2 perks as a reward for your loyalty towards us...they are:\n"\
    "🔅Auto and confirmed entry into the finalé of Addict's Hunger Games 2018." \
    "🔅 A free sponsor prize to help you crush the other district tributes.\n\n" \
    "⛔️But since nothing in this world comes for free; for this as well, you will have to pay a price "\
    "i.e. you will have to renounce and leave your district.\n\n" \
    "Will you join us⁉️\n\n"\
    "Are you strong enough; loyal enough; confident enough⁉️\n\n"\
    "⚠️ Tell no one about this discussion, or the wrath of the Capitol 👑 will be harsh for you as well as your family."\
    " You have 2hours to reply.\n\n"\
    "Choose wisely, and may the odds be ever in your favour! 🌝" \
    "\n\nP.S.  ONLY accept this invitation, "\
    "if you are available to play in the Addict's Hunger Games Finalé 2018 on 30th and 31st July!"

    buttons = [
        [{
             text: 'Sure, let me in',
             callback_data: "{type: '#{UserFlow::CAPITOL_INVITATION_CALLBACK_TYPE}', user_id: #{user.id}, accept: true}"
         }],
        [{
             text: 'No, I\'m loyal to my district',
             callback_data: "{type: '#{UserFlow::CAPITOL_INVITATION_CALLBACK_TYPE}', user_id: #{user.id}, accept: false}"
         }]
    ]

    TelegramClient.make_inline_buttons(user.telegram_id,
                                       message,
                                       buttons)
  end
end
