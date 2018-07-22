namespace :notify do
  desc 'Rake task to notify users of leaderboards'
  task district_leaderboard: :environment do
    District.find_each do |district|
      leaderboard_message = district.leaderboard

      district.users.each do |user|
        TelegramClient.send_message(user.telegram_id,
                                    leaderboard_message) if user.is_admin?
      end
    end
  end
end