Rails.application.routes.draw do
  # Callbacks used for the call logic
  post 'answer', to: 'calls#answer_cb'
  post 'gather', to: 'calls#gather_cb'
  post 'voicemail', to: 'calls#voicemail_cb'
  post 'dial', to: 'calls#dial_cb'

  # CRUD view to list the calls
  resources :calls
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
