namespace :notify do
  desc 'Rake task to notify users of leaderboards'
  task goodbye: :environment do
    message = "I the bot 🤖 officially thank you for playing and making this event a success,"\
    " I shall officially retire this week 😅😅😅\n" \
    "Me and my master @CrapKnight are grateful for your participation, and for any feedback (or praise) please do PM him\n"\
    "\nWith this I bid thee farewell, friends, tributes, sacrifices...\n"\
    "May the odds be never... *ahem... May the odds be ever in your favour"

    User.find_each do |user|
      begin
        TelegramClient.send_message(user.telegram_id,message,nil)
      rescue => e
        UserFlow.new.inform_super_admins("Unable to send farewell message to #{user.full_name}:\n#{e.message}")
      end
    end
  end
end