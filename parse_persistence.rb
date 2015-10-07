require 'parse-ruby-client'

class ParsePersistence

  def initialize(options)
    @parse = Parse.create(:application_id => options[:app_id],
                 :api_key => options[:api_key],
                 :quiet  => true)
  end

  def set_key(user, key, value)
    page = get_page(user)
    page = create_page(user) unless page
    page[key] = value
    page.save
  end

  def get_page(user)
    query = @parse.query("Page")
    results = query.eq("user",user).get
    results.first
  end

  def create_page(user)
    page = @parse.object("Page")
    page["user"] = user
    page
  end




end