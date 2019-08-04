Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'twilio/initial'
  post 'twilio/keys'
  post 'twilio/recording'
  post 'twilio/status'
end
