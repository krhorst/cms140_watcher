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

parse_persistence = ParsePersistence.new(:application_id => PARSE_APPLICATION_ID, :api_key => PARSE_API_KEY)
commands = [SetTemplateVariableCommand]

TweetStream::Client.new.userstream do |status|
   TweetHandler.new(:tweet => status,:commands => commands,:persistence => parse_persistence)
end