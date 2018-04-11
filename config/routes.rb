Rails.application.routes.draw do
  post 'calls/incoming'

  post 'calls/voicemail_handler'

  get 'calls/status_handler'
end
