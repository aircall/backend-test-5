Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'calls#index'

  scope '/calls', :controller => :calls do
    post :ivr
    get  :ivr_menu_selection
  end

end
