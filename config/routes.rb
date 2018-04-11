Rails.application.routes.draw do
  get 'calls/test'
  post 'calls/incoming'
  get 'calls/status'
end
