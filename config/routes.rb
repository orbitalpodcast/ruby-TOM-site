Rails.application.routes.draw do
  root 'pages#index'
  resources :episodes, except: :new, param: :slug_or_number     # Not sure if TOM.com/### is an episode number or a slug, so pass it through and decide in Episode.set_episode

  get '/draft', to: 'episodes#new',
    constraints: lambda { |request| !Episode.draft_waiting? }
  get '/draft', to: 'episodes#edit',                            # TODO: this seems wrong. Shouldn't /draft route to episodes#incoming_draft or something, which redirects from there?
    constraints: lambda { |request| Episode.draft_waiting? }
end