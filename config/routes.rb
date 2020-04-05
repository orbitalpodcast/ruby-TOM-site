Rails.application.routes.draw do
  devise_for :users, path: 'user',
                     controllers: {
                       confirmations:  'users/confirmations',
                       passwords:      'users/passwords',
                       registrations:  'users/registrations',
                       sessions:       'users/sessions',
                       unlocks:        'users/unlocks'
                     }
  devise_for :admins, path: 'admin',
                      only: [:sessions, :unlocks],
                      controllers: {
                        sessions: 'admins/sessions',
                        unlocks:  'admins/unlocks'
                      }

  root 'pages#index'

  # USERS
  get 'newsletter',  to: 'newsletter#new'
  post 'newsletter', to: 'newsletter#create'
  get 'newsletter/unsubscribe/:quick_unsubscribe_token', to: 'newsletter#unsubscribe', as: 'unsubscribe_newsletter'
  resources :users
  # resources :users, param: :access_token, only: [:index, :show, :destroy]
  get 'welcome',    to: 'users#welcome' # TODO: move newsletter welcome to static controller


  # COMMERCE
  # get   'store',                                  to: 'orders#new',    as: 'order'
  # post  '/store',                                 to: 'orders#create'
  # get   '/store/:id',                             to: 'orders#edit',   as: 'edit_order'
  # patch '/store/:id',                             to: 'orders#update'
  get   '/order_return/:payment_gateway/:payment_status', to: 'orders#finish'
  get 'store', to: 'orders#new', as: 'store'
  resources :orders

  # BOT SUPPORT
  # patch 'upload_image/:number', to: 'episodes#upload_image', as: 'upload_image'
  # patch 'upload_audio/:number', to: 'episodes#upload_audio', as: 'upload_audio'
  

  # EPISODES
  get '/episodes/:begin/to/:end', to: 'episodes#index', as: 'episodes_with_range'
  get '/draft',                   to: 'episodes#draft'
  # Redirect legacy URLs
  get '/show-notes/:slug',        to: redirect('episodes/%{slug}')
  get '/show-notes/*date/:slug',  to: redirect('episodes/%{slug}')
  resources :episodes
  # Redirect direct paths
  get :episodes, path: '/:slug',   constraints: { slug: /[\w-]+/ }, to: redirect('episodes/%{slug}')
  get :episodes, path: '/:number', constraints: { number: /\d+/ },  to: redirect('episodes/%{number}')

end
