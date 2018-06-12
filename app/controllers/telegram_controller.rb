class TelegramController < ApplicationController
  def call
   CallParser.process(params[:message])
  end
end