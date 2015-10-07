class SetTemplateVariableCommand < BaseCommand


  def meets_criteria
     @tweet.text.include?("#")
  end

  def execute
    user_name = get_username_from_tweet
    key_name = get_key_name_from_tweet
    value = get_value_from_tweet
    @persistence.set_key(user_name,key_name, value) if key_name.length > 0
  end

  def get_key_name_from_tweet
    words = @tweet.text.split(" ")
    first_command = words.each do |w|
      break w if w.start_with?("#")
    end
    first_command.gsub("#","")
  end

  def get_value_from_tweet
    words = @tweet.text.split(" ")
    filtered_words = words.map do |w|
      w unless w.start_with?("#","@",".@")
    end
    filtered_words.compact.join(" ")
  end

  def get_username_from_tweet
    @tweet.user.screen_name
  end

end