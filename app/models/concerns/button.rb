class Button
  AGREE = '🌟I understand 🌟'
  START = 'Lets start'

  BACK = '◀️ Back'

  ADMIN_TEXT = 'Add more fun texts'
  ADMIN_GROUP_QUESTION = "Add a question for #{Figaro.env.group_name.pluralize}"
  ADMIN_LAST_10_GAMES = 'View last 10 games stored'
  ADMIN_GROUP_DESC = "Change #{Figaro.env.group_name} description"
  ADMIN_GROUP_LEADERBOARD = "View #{Figaro.env.group_name} leaderboard"
  ADMIN_VIEW_MISSING_PLAYERS = 'Untracked player list'

  VIEW_STATS = '📊 My Games 📊'
  VIEW_GAME_COUNT = '📈Game Count📈'
  GROUP = "🏤 My #{Figaro.env.group_name} 🏤"
  VIEW_SCORE = '✨My Score💫'
  LEADERBOARD = '📈View Leaderboard🌟'

  def self.default_buttons
    [[VIEW_STATS,VIEW_SCORE],[VIEW_GAME_COUNT,GROUP],[LEADERBOARD]]
  end
end