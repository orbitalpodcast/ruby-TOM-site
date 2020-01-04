Rails.application.routes.draw do
  root 'pages#index'

  resources :users, param: :access_token, except: :new
  get   'login',    to: 'sessions#new'
  post  'login',    to: 'sessions#create'
  get  'logout',    to: 'sessions#destroy'
  get 'newsletter', to: 'users#new'
  get 'welcome',    to: 'users#welcome'

  resources :episodes, except: :new, param: :slug_or_number
  get '/draft',            to: 'episodes#draft'
  get '/show-notes/:slug', to: redirect('episodes/%{slug}')
  get '/:number',          to: redirect('episodes/%{number}'), constraints: { number: /\d+/ }
  # resources :episodes, except: :new, param: :number,           constraints: { number: /\d+/ }
  get '/:slug',            to: redirect('episodes/%{slug}'),   constraints: { slug: /[\w-]+/ }
  # resources :episodes, except: :new, param: :slug,             constraints: { slug: /[\w-]+/ }
end