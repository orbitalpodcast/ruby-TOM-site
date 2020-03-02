# Initialize RedditBot object. Currently disabled in all but development.
require 'reddit_bot'

# fake bot for test environment
class FakeRedditBot
  def json method, params, form
    return {"json"=>
              {"errors"=>[],
                "data"=>{
                  "url"=>"https://www.reddit.com/r/tomcast_bottest/comments/fbzc16/episode_241_clock_kerfuffle/",
                  "drafts_count"=>0,
                  "id"=>"fbzc16",
                  "name"=>"t3_fbzc16"}}}
  end
end



# if ENV["RAILS_ENV"] == 'production'
#   REDDIT_CLIENT = RedditBot::Bot.new(
#     user_agent:    'TOM-site:v1.0 (by /u/hapax_legomina)',
#     client_id:     ENV['REDDIT_CLIENT_ID'],
#     client_secret: ENV['REDDIT_SECRET'],
#     login:         ENV['REDDIT_USERNAME'],
#     password:      ENV['REDDIT_PASSWORD']
#   )
#   DEFAULT_REDDIT_PARAMS = {'sr':          'orbitalpodcast',
#                            'kind':        'link',
#                            'sendreplies': 'true'}
# end

if ENV["RAILS_ENV"] == 'development'
  REDDIT_CLIENT = RedditBot::Bot.new(
    user_agent:    'TOM-site:v1.0 (by /u/hapax_legomina)',
    client_id:     ENV['REDDIT_CLIENT_ID'],
    client_secret: ENV['REDDIT_SECRET'],
    login:         ENV['REDDIT_USERNAME'],
    password:      ENV['REDDIT_PASSWORD']
  )
  DEFAULT_REDDIT_PARAMS = {'sr':          'tomcast_bottest',
                           'kind':        'link',
                           'sendreplies': 'true'}
end

if ENV["RAILS_ENV"] == 'test'
  REDDIT_CLIENT = FakeRedditBot.new()
  DEFAULT_REDDIT_PARAMS = {}
end
