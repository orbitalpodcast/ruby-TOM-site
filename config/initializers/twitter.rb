require 'twitter'

TWITTER_CLIENT = Twitter::REST::Client.new do |config|
  config.consumer_key        = Rails.configuration.twitter[:consumer_key]
  config.consumer_secret     = Rails.configuration.twitter[:consumer_secret]
  config.access_token        = Rails.configuration.twitter[:access_token]
  config.access_token_secret = Rails.configuration.twitter[:access_token_secret]
end
