class Button
  AGREE = '🌟I understand 🌟'
  START = 'Lets start'

  BACK = '◀️ Back'

  ADMIN_TEXT = 'Add more fun texts'
  ADMIN_DISTRICT_QUESTION = 'Add a question for Districts'
  ADMIN_LAST_10_GAMES = 'View last 10 games stored'
  ADMIN_DISTRICT_DESC = 'Change district description'

  VIEW_STATS = '📊 My Games 📊'
  DISTRICT = '🏤 My District 🏤'
  VIEW_SCORE = '✨My Score💫'

  def self.default_buttons
    [[VIEW_STATS,VIEW_SCORE],[DISTRICT]]
  end
end