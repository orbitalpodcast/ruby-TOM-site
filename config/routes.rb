Rails.application.routes.draw do
  root 'pages#index'

  get 'newsletter', to: 'users#new'
  resources :newsletter, controller: 'users', as: 'users', param: :access_token, except: [:index, :show, :destroy]
  resources :users, param: :access_token, only: [:index, :show, :destroy]
  get   'login',    to: 'sessions#new'
  post  'login',    to: 'sessions#create'
  get  'logout',    to: 'sessions#destroy'
  get 'welcome',    to: 'users#welcome' # TODO: move newsletter welcome to static controller

  get '/episodes',         to: 'episodes#index'
  get '/draft',            to: 'episodes#draft'
  # Redirect legacy URLs
  get '/show-notes/:slug', to: redirect('/%{slug}')

  resources :episodes
  # Redirect direct paths
  get :episodes, path: '/:slug',   constraints: { slug: /[\w-]+/ }, to: redirect('episodes/%{slug}')
  get :episodes, path: '/:number', constraints: { number: /\d+/ },  to: redirect('episodes/%{number}')

end
