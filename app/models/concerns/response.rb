class Response < ActiveRecord::Base
  validates_presence_of :key, :text

  enum key: [:welcome, :spam, :smart_ass]

  def self.get_random_text(key)
    set = where(key: key)
    set.offset(rand(set.count)).first.text
  end
end