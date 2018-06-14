class TelegramController < ApplicationController
  def call
   CallParser.process(params[:message], @user)
  end
end