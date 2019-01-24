Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "call#home"


  resources :calls, only: :none do
    post :home, on: :collection
    post :incoming, on: :collection
  end
end
