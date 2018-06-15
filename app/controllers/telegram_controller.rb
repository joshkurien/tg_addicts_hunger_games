class TelegramController < ApplicationController
  def call
    if params[:callback_query].present?
      CallbackParser.process(params[:callback_query])
    else
      CallParser.process(params[:message])
    end
    render status: 200
  end
end