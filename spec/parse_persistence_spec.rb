require_relative 'spec_helper'
require_relative '../parse_persistence'

describe ParsePersistence do

  before(:each) do
    @fake_parse_client = instance_double("FakeParseClient")
    allow(Parse).to receive(:create).and_return(@fake_parse_client)
    @parse_object = instance_double("FakeParseObject")
  end

  it "should initialize a client" do
    expect(Parse).to receive(:create)
    @parse_persistence = ParsePersistence.new(:application_id => "", :api_key => "")
  end

  describe "get_page" do

    before(:each) do
      @parse_persistence = ParsePersistence.new(:application_id => "", :api_key => "")
      @mock_query = instance_double("FakeQuery")
      expect(@fake_parse_client).to receive(:query).with("Page").and_return(@mock_query)
      expect(@mock_query).to receive(:eq).with("user", "username").and_return(@mock_query)

    end

    it "should return the first result if matching page exists" do
      expect(@mock_query).to receive("get").and_return([@parse_object])
      expect(@parse_persistence.get_page("username")).to eq(@parse_object)
    end

    it "should return false if no page exists" do
      expect(@mock_query).to receive("get").and_return([])
      expect(@parse_persistence.get_page("username")).to be_falsy
    end

  end

  describe "set_key" do

    before(:each) do
      @parse_persistence = ParsePersistence.new(:application_id => "", :api_key => "")
    end

    describe "with valid key" do

      before(:each) do
        expect(@parse_object).to receive(:[]=).with("key", "value")
        expect(@parse_object).to receive(:save)
      end

      it "should call create page if page does not exist" do
        expect(@parse_persistence).to receive(:get_page).and_return(false)
        expect(@parse_persistence).to receive(:create_page).and_return(@parse_object)
        @parse_persistence.set_key("user", "key", "value")
      end

      it "should not call create page if page exists" do
        expect(@parse_persistence).to receive(:get_page).and_return(@parse_object)
        expect(@parse_persistence).not_to receive(:create_page)
        @parse_persistence.set_key("user", "key", "value")
      end

    end

    describe "invalid keys" do

      before(:each) do
        expect(@parse_persistence).not_to receive(:save)
        expect(@parse_persistence).not_to receive(:get_page)
        expect(@parse_persistence).not_to receive(:create_page)
      end

      it "should not set the key if trying to set id" do
        @parse_persistence.set_key("user", "id", "value")
      end

      it "should not set the key if trying to set id" do
        @parse_persistence.set_key("user", "createdAt", "value")
      end

      it "should not set the key if trying to set id" do
        @parse_persistence.set_key("user", "updatedAt", "value")
      end

    end

  end

  describe "create_page" do

    it "should create a parse object with user set" do
      @parse_persistence = ParsePersistence.new(:application_id => "", :api_key => "")
      expect(@fake_parse_client).to receive(:object).and_return(@parse_object)
      expect(@parse_object).to receive(:[]=).with("user", "username")
      @parse_persistence.create_page("username")
    end

  end

end