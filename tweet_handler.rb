class TweetHandler

  def initialize(tweet, commands)
    @tweet = tweet
    @commands = commands
  end

  def find_command
    @commands.each do |command|
      if command.meets_criteria(@tweet)
        command.execute(@tweet)
        break
      end
    end
  end

end