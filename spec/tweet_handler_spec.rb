require_relative 'spec_helper'
require_relative '../tweet_handler'

describe TweetHandler do

  before(:each) do
    @tweet = instance_double("Tweet")
    @command_1 = instance_double("TweetCommand")
    @command_1_class = double("TweetCommand", :new => @command_1)
    @command_2 = instance_double("OtherTweetCommand")
    @command_2_class = double("OtherTweetCommand", :new => @command_2)
    @persistence = double("FakePersistence")
  end

  describe "one matching command" do
    before(:each) do
      @tweet_handler = TweetHandler.new(:tweet => @tweet, :commands => [@command_1_class], :persistence => @persistence)
    end

    it "should call execute on command if criteria is met" do
      expect(@command_1).to receive(:meets_criteria).and_return(true)
      expect(@command_1).to receive(:execute)
      @tweet_handler.find_command
    end

    it "should not call execute on command if criteria is not met" do
      expect(@command_1).to receive(:meets_criteria).and_return(false)
      expect(@command_1).not_to receive(:execute)
      @tweet_handler.find_command
    end
  end

  describe "multiple matching commands" do

    before(:each) do
      @tweet_handler = TweetHandler.new(:tweet => @tweet, :commands => [@command_1_class, @command_2_class], :persistence => @persistence)
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