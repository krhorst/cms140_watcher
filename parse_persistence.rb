require 'parse-ruby-client'

class ParsePersistence

  def initialize(options)
    @parse = Parse.create({:application_id => options[:app_id],
                          :api_key => options[:api_key],
                          :quiet => false})
  end

  def set_key(user, key, value)
    unless blacklist_keys.include? key
      page = get_page(user)
      page = create_page(user) if page == false
      page[key] = value
      page.save
    end
  end

  def get_page(user)
    query = @parse.query("Page")
    results = query.eq("user", user).get
    results.first.nil? ? false : results.first
  end

  def create_page(user)
    page = @parse.object("Page")
    page["user"] = user
    page
  end

  private

  def blacklist_keys
    ["id","createdAt","updatedAt","user"]
  end


end