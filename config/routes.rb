Rails.application.routes.draw do

  post "/webhooks/#{Figaro.env.bot_route}" => 'telegram#call'

  get 'ping' => 'ping#ping'
end
