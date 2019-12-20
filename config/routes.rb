Rails.application.routes.draw do
  root 'pages#index'
  resources :episodes, except: :new, param: :slug_or_number     # Not sure if TOM.com/### is an episode number or a slug, so pass it through and decide in Episode.set_episode

  get '/draft', to: 'episodes#draft'
  get '/show-notes/:slug', to: redirect('episodes/%{slug}')
  
  get '/:number',          to: redirect('episodes/%{number}'), constraints: { number: /\d+/ }
  # resources :episodes, except: :new, param: :number,           constraints: { number: /\d+/ }

  get '/:slug',            to: redirect('episodes/%{slug}'),   constraints: { slug: /[\w-]+/ }
  # resources :episodes, except: :new, param: :slug,             constraints: { slug: /[\w-]+/ }

end