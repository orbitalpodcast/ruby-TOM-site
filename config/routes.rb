Rails.application.routes.draw do
  root 'pages#index'
  resources :episodes, except: :new, param: :slug_or_number

  get '/draft', to: 'episodes#new'
end
