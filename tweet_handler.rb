class TweetHandler

  def initialize(options)
    @tweet = options[:tweet]
    @commands = options[:commands]
    @persistence = options[:persistence]
  end

  def find_command
    @commands.each do |command|
      command_instance = command.new(:tweet => @tweet, :persistence => @persistence)
      if command_instance.meets_criteria
        command_instance.execute(@tweet)
        break
      end
    end
  end

end