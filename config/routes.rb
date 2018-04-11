Rails.application.routes.draw do
  get 'calls', to: 'calls#index'

  post 'calls/incoming'

  post 'calls/voicemail_handler'

  get 'calls/status_handler'
end
