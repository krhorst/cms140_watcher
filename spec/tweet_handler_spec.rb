require_relative 'spec_helper'
require_relative '../tweet_handler'

describe TweetHandler do

  describe "one matching command" do
    before(:each) do
      @tweet = double("Tweet")
      @command = double("TweetCommand")
      @tweet_handler = TweetHandler.new(@tweet, [@command])
    end

    it "should call execute on command if criteria is met" do
      expect(@command).to receive(:meets_criteria).and_return(true)
      expect(@command).to receive(:execute)
      @tweet_handler.find_command
    end

    it "should not call execute on command if criteria is not met" do
      expect(@command).to receive(:meets_criteria).and_return(false)
      expect(@command).not_to receive(:execute)
      @tweet_handler.find_command
    end
  end

  describe "multiple matching commands" do

    before(:each) do
      @tweet = double("Tweet")
      @command_1 = double("TweetCommand")
      @command_2 = double("OtherTweetCommand")
      @tweet_handler = TweetHandler.new(@tweet, [@command_1, @command_2])
    end

    it "should only execute the first one" do
      expect(@command_1).to receive(:meets_criteria).and_return(true)
      expect(@command_2).not_to receive(:meets_criteria)
      expect(@command_1).to receive(:execute)
      expect(@command_2).not_to receive(:execute)
      @tweet_handler.find_command
    end

  end

end