class Button
  AGREE = '🌟I understand 🌟'
  START = 'Lets start'

  ADMIN_TEXT = 'Add more fun texts'
  ADMIN_DISTRICT_QUESTION = 'Add a question for Districts'
  ADMIN_LAST_10_GAMES = 'View last 10 games stored'

  VIEW_STATS = '📊 My Games 📊'
  DISTRICT = '🏤 My District 🏤'

  def self.default_buttons
    [[VIEW_STATS],[DISTRICT]]
  end
end