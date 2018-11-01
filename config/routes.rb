Rails.application.routes.draw do
  root 'calls#index'
  post 'ivr/start', to: 'calls#start'
  post 'ivr/response', to: 'calls#user_response'
  post 'ivr/forward', to: 'calls#forward'
  post 'ivr/record', to: 'calls#record'
  post 'ivr/after-record', to: 'calls#after_record'
  post 'ivr/call-status-change', to: 'calls#call_status_change'
end
