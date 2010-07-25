$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require "geocaching"
require "helper"

describe "Geocaching::Log for a3237dec-6931-4221-8f00-5d62923b411a" do
  before :all do
    @log = Geocaching::Log.fetch(:guid => "a3237dec-6931-4221-8f00-5d62923b411a")
  end

  it "should return the correct username" do
    @log.username.should == "CampinCrazy"
  end

  it "should return the correct cache GUID" do
    @log.cache.guid.should == "66274935-40d5-43d8-8cc3-c819e38f9dcc"
  end

  it "should return the correct message" do
    should_message = File.read(File.join(File.dirname(__FILE__), "log_message.txt"))
    @log.message.should == should_message.gsub(/\r\n/, "\n")
  end
end
