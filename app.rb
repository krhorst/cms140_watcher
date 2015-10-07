require_relative 'app.env.rb'
require_relative 'commands/*.rb'
require 'tweetstream'

TweetStream.configure do |config|
  config.consumer_key        = CONSUMER_KEY
  config.consumer_secret     = CONSUMER_SECRET
  config.oauth_token        = ACCESS_TOKEN
  config.oauth_token_secret = ACCESS_SECRET
  config.auth_method        = :oauth
end

TweetStream::Client.new.userstream do |status|
  puts status.text
end