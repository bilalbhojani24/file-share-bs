Rails.application.routes.draw do
  root 'document#index'
  devise_for :users, controllers: { registrations: "registrations" }
  resources :document, except: [:edit, :new]
end
