Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'calls#index'

  post '/calls/ivr', to: 'calls#ivr'
  scope '/calls/:call_id', :controller => :calls do
    #post :ivr
    post :ivr_menu_select
    post :create_voicemail
  end

end
