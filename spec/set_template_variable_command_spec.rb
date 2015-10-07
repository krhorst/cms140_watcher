require_relative 'spec_helper'
require_relative '../commands/base_command'
require_relative '../commands/set_template_variable'

describe SetTemplateVariableCommand do

  before(:each) do
    @persistence = instance_double("FakePersistence")
  end

  it "should meet criteria if tweet has a hashtag" do
    tweet = double("Tweet", :text => "@cms140 #title My Title")
    command = SetTemplateVariableCommand.new(:tweet => tweet, :persistence => @persistence)
    expect(command.meets_criteria).to be_truthy
  end

  it "should not meet criteria if tweet has no hashtag" do
    tweet = double("Tweet", :text => "@cms140 My Title")
    command = SetTemplateVariableCommand.new(:tweet => tweet, :persistence => @persistence)
    expect(command.meets_criteria).to be_falsey
  end

  describe "execute" do

    it "should call update on key matching hashtag" do
      tweet = double("Tweet", :text => "@cms140 #title My Title", :user => double("User",:screen_name => "fakeuser"))
      command = SetTemplateVariableCommand.new(:tweet => tweet, :persistence => @persistence)
      expect(@persistence).to receive(:set_key).with("fakeuser","title","My Title")
      command.execute
    end

    it "should work with .@ mentions" do
      tweet = double("Tweet", :text => ".@cms140 #title My Title", :user => double("User",:screen_name => "fakeuser"))
      command = SetTemplateVariableCommand.new(:tweet => tweet, :persistence => @persistence)
      expect(@persistence).to receive(:set_key).with("fakeuser","title","My Title")
      command.execute
    end

    it "should not attempt to update if hashtag is empty" do
      tweet = double("Tweet", :text => ".@cms140 # My Title", :user => double("User",:screen_name => "fakeuser"))
      command = SetTemplateVariableCommand.new(:tweet => tweet, :persistence => @persistence)
      expect(@persistence).not_to receive(:set_key)
      command.execute
    end


  end

end

