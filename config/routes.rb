Rails.application.routes.draw do
  root 'pages#index'
  resources :episodes, except: :new, param: :slug_or_number     # Not sure if TOM.com/### is an episode number or a slug, so pass it through and decide in Episode.set_episode

  get '/draft', to: 'episodes#new'
end
