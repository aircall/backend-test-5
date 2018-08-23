Rails.application.routes.draw do

  post 'twilio/voice' => 'call#base_reply'
  post 'twilio/response' => 'call#handle_response'
  post 'twilio/redirect_status' => 'call#handle_redirect'
  post 'twilio/recording_started' => 'call#handle_recording_started'
  post 'twilio/recording_finished' => 'call#handle_recording_finished'
  post 'twilio/status' => 'call#update_call_status'

  resource :call
  get '/' => 'call#index'
  delete 'call/:id(.:format)' => 'call#destroy'
  get 'calls/refresh' => 'call#table_refresh'

end
