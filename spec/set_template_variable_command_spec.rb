require_relative 'spec_helper'
require_relative '../commands/base_command'
require_relative '../commands/set_template_variable'

describe SetTemplateVariable do

  before(:each) do
    @persistence = instance_double("FakePersistence")
  end

  it "should meet criteria if tweet has a hashtag" do
    tweet = double("Tweet", :text => "@cms140 #title My Title")
    command = SetTemplateVariable.new(:tweet => tweet, :persistence => @persistence)
    expect(command.meets_criteria).to be_truthy
  end

  it "should not meet criteria if tweet has no hashtag" do
    tweet = double("Tweet", :text => "@cms140 My Title")
    command = SetTemplateVariable.new(:tweet => tweet, :persistence => @persistence)
    expect(command.meets_criteria).to be_falsey
  end

  describe "execute" do

    it "should call update on key matching hashtag" do
      tweet = double("Tweet", :text => "@cms140 #title My Title")
      command = SetTemplateVariable.new(:tweet => tweet, :persistence => @persistence)
      expect(@persistence).to receive(:update).with("title","My Title")
      command.execute
    end


  end

end

