Rails.application.routes.draw do
  resources :calls, only: %i[index create]
  match 'handle_input' => 'calls#handle_input', via: :post
  match 'change_status' => 'calls#change_status', via: :post
  match 'handle_invalid_input' => 'calls#handle_invalid_input', via: :get
  mount ActionCable.server => '/cable'

  root to: 'calls#index'
end
