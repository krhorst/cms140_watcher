current_folder = File.expand_path('../', __FILE__)
Dir["#{current_folder}/commands/*.rb"].each {|f| require f}

require_relative 'app.env.rb'
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