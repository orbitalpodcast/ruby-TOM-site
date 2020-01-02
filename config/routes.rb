Rails.application.routes.draw do
  root 'pages#index'

  resources :users, only: [:new, :create]
  get   'login',    to: 'sessions#new'
  post  'login',    to: 'sessions#create'
  get  'logout',    to: 'sessions#destroy'
  get 'welcome',    to: 'sessions#welcome'

  resources :episodes, except: :new, param: :slug_or_number
  get '/draft',            to: 'episodes#draft'
  get '/show-notes/:slug', to: redirect('episodes/%{slug}')
  get '/:number',          to: redirect('episodes/%{number}'), constraints: { number: /\d+/ }
  # resources :episodes, except: :new, param: :number,           constraints: { number: /\d+/ }
  get '/:slug',            to: redirect('episodes/%{slug}'),   constraints: { slug: /[\w-]+/ }
  # resources :episodes, except: :new, param: :slug,             constraints: { slug: /[\w-]+/ }
end