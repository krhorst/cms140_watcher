require 'tweetstream'

current_folder = File.expand_path('../', __FILE__)
Dir["#{current_folder}/commands/*.rb"].each { |f| require f }

require_relative 'app.env.rb'
require_relative 'parse_persistence'
require_relative 'tweet_handler'

TweetStream.configure do |config|
  config.consumer_key = CONSUMER_KEY
  config.consumer_secret = CONSUMER_SECRET
  config.oauth_token = ACCESS_TOKEN
  config.oauth_token_secret = ACCESS_SECRET
  config.auth_method = :oauth
end

parse_persistence = ParsePersistence.new({:app_id => PARSE_APPLICATION_ID, :api_key => PARSE_API_KEY})
commands = [SetTemplateVariableCommand]

TweetStream::Client.new.userstream do |status|
  begin
    handler = TweetHandler.new({:tweet => status, :commands => commands, :persistence => parse_persistence})
    handler.find_command
  rescue => e
    e.inspect
  end

end