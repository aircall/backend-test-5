Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "calls#home"

  namespace :calls do
    resource :incoming, only: :create
    resource :sorted, only: :create
    resource :recorded, only: :create
    resource :finished, only: :create
  end

  resources :calls, only: :none do
    post :home, on: :collection
  end
end
