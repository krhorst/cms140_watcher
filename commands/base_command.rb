class BaseCommand

  def initialize(options)
    @tweet = options[:tweet]
    @persistence = options[:persistence]
  end


end