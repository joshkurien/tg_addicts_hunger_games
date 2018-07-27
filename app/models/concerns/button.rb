class Button
  AGREE = '🌟I understand 🌟'
  START = 'Lets start'

  BACK = '◀️ Back'

  ADMIN_TEXT = 'Add more fun texts'
  ADMIN_DISTRICT_QUESTION = 'Add a question for Districts'
  ADMIN_LAST_10_GAMES = 'View last 10 games stored'
  ADMIN_DISTRICT_DESC = 'Change district description'
  ADMIN_DISTRICT_LEADERBOARD = 'View District leaderboard'
  ADMIN_VIEW_MISSING_PLAYERS = 'Untracked player list'

  VIEW_STATS = '📊 My Games 📊'
  VIEW_GAME_COUNT = '📈Game Count📈'
  DISTRICT = '🏤 My District 🏤'
  VIEW_SCORE = '✨My Score💫'

  def self.default_buttons
    [[VIEW_STATS,VIEW_SCORE],[VIEW_GAME_COUNT],[DISTRICT]]
  end
end