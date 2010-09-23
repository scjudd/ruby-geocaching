# encoding: utf-8

describe "Geocaching::Log for 83a3f4f4-7faf-414a-8145-8f334622d20f (Disable Listing)" do
  before :all do
    @log = Geocaching::Log.fetch(:guid => "83a3f4f4-7faf-414a-8145-8f334622d20f")
  end

  it "should return the correct username" do
    @log.username.should == "CacheHasen"
  end

  it "should return the correct cache GUID" do
    @log.cache.guid.should == "65f58a1c-916b-4b32-a656-e80964b6819b"
  end

  it "should return the correct type" do
    @log.type.to_sym.should == :disable
  end

  it "should return the correct date" do
    @log.date.should == Time.mktime(2010, 3, 13)
  end

  it "should return the correct message" do
    should_message = File.read(__FILE__.gsub(/rb$/, "txt"))
    @log.message.should == should_message.gsub(/\r\n/, "\n")
  end
end
