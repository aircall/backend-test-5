Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'ivr/give_choice', defaults: { format: 'xml' }
  post 'ivr/process_selected_choice', defaults: { format: 'xml' }
  post 'ivr/voice_mail_redirection', defaults: { format: 'xml' }
  post 'ivr/phone_redirection', defaults: { format: 'xml' }
  post 'ivr/process_incoming_call'
  resources :calls, only: [:index]
  root 'calls#index'
end
