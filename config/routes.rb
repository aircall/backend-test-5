Rails.application.routes.draw do
  root 'calls#index'
  post '/call', to: 'calls#call'
  post '/update', to: 'calls#update'

  mount ActionCable.server, at: '/cable'
end
