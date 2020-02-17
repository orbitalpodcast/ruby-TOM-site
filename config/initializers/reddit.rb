require 'reddit_bot'

if ENV["RAILS_ENV"] == 'development'
  REDDIT_CLIENT = RedditBot::Bot.new(
    user_agent:    'TOM-site:v1.0 (by /u/hapax_legomina)',
    client_id:     ENV['REDDIT_CLIENT_ID'],
    client_secret: ENV['REDDIT_SECRET'],
    login:         ENV['REDDIT_USERNAME'],
    password:      ENV['REDDIT_PASSWORD']
  )
  DEFAULT_REDDIT_PARAMS = {'sr':          'orbitalpodcast',
                           'kind':        'link',
                           'sendreplies': 'true'}
end