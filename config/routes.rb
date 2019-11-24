Rails.application.routes.draw do
  root 'pages#index'
  resources :episodes, param: :slug_or_number
end
