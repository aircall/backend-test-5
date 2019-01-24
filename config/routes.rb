Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :calls, only: :none do
    post :incoming, on: :collection
  end
end
