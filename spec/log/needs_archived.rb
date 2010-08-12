# encoding: utf-8

describe "Geocaching::Log for d235f46e-cd16-49af-a520-fa52f6c8abf8 (Needs Archived)" do
  before :all do
    @log = Geocaching::Log.fetch(:guid => "d235f46e-cd16-49af-a520-fa52f6c8abf8")
  end

  it "should return the correct username" do
    @log.username.should == "Kent_Allard"
  end

  it "should return the correct cache GUID" do
    @log.cache.guid.should == "b39d3cf0-88ad-4402-ba42-29879ecb5814"
  end

  it "should return the correct type" do
    @log.type.to_sym.should == :needs_archived
  end

  it "should return the correct date" do
    @log.date.should == Time.mktime(2008, 6, 15)
  end

  it "should return the correct message" do
    should_message = File.read(__FILE__.gsub(/rb$/, "txt"))
    @log.message.should == should_message.gsub(/\r\n/, "\n")
  end
end
