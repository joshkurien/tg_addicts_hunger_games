class User < ActiveRecord::Base
  enum status: [:created, :registering, :allocated]

  def self.get_user(from_params)
    user = find_by_telegram_id(from_params[:id].to_i)
    return user unless user.nil?

    register_user(from_params)
  end

  private
  def self.register_user(info)
    User.create(username: info[:username], telegram_id: info[:id],
                first_name: info[:first_name], last_name: info[:last_name],
                is_bot: info[:is_bot], language: info[:language_code])
  end
end