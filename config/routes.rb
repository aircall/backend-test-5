Rails.application.routes.draw do
  root 'calls#index'
  post 'ivr/welcome', to: 'calls#start'
  post 'ivr/response', to: 'calls#user_response'
  post 'ivr/forward', to: 'calls#forward'
  post 'ivr/record', to: 'calls#record'
  post 'ivr/after-record', to: 'calls#after_record'
end
