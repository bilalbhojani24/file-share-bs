Rails.application.routes.draw do
  root 'document#index'

  resources :document, except: [:edit, :new]
  
  get '/sign_in', to: 'user#sign_in'
  post '/sign_in', to: 'user#sign_in!'
  get '/sign_up', to: 'user#sign_up'
  post '/sign_up', to: 'user#sign_up!'
  get '/update/:username', to: 'user#update'
  post '/update', to: 'user#update!'
  get '/sign_out', to: 'user#sign_out'
end
