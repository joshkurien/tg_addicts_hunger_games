namespace :notify do
  desc 'Rake task to notify users of leaderboards'
  task group_leaderboard: :environment do
    Group.find_each do |group|
      leaderboard_message = group.leaderboard

      group.users.each do |user|
        TelegramClient.send_message(user.telegram_id,
                                    leaderboard_message) if user.is_admin?
      end
    end
  end
end