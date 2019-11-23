Rails.application.routes.draw do
  root 'episodes#index'
  resources :episodes, param: :slug_or_id
end
