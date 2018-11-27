class TelegramController < ApplicationController
  def call
    begin
      if params[:callback_query].present?
        CallbackParser.process(params[:callback_query])
      elsif params[:message][:forward_from].present?
        ForwardParser.process(params[:message])
      else
        CallParser.process(params[:message])
      end
    rescue => e
      UserFlow.new.inform_super_admins("Message from: #{ params[:message][:from][:first_name]}\nID: #{params[:message][:from][:id]}\n" +
                                           "Message: #{params[:message][:text]}\n" +
                                           "\nError message:\n" + e.message + "\nTrace:\n" +
                                           e.backtrace[0] + "\n" + e.backtrace[1] )
    end
    render status: 200
  end
end