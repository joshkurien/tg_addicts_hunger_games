class ApplicationController < ActionController::API
  before_action :get_user

  def get_user
    @user = User.get_user(params[:message][:from])
  end
end
