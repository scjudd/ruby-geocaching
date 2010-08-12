# encoding: utf-8

describe "Geocaching::Log for 58fa3ddc-6c1a-4ae3-bc19-40009c50a9d5 (Retract Listing)" do
  before :all do
    @log = Geocaching::Log.fetch(:guid => "58fa3ddc-6c1a-4ae3-bc19-40009c50a9d5")
  end

  it "should return the correct username" do
    @log.username.should == "WGA3"
  end

  it "should return the correct cache GUID" do
    @log.cache.guid.should == "d4249438-50e9-41b8-bafb-3f9e72e25f5a"
  end

  it "should return the correct type" do
    @log.type.to_sym.should == :retract
  end

  it "should return the correct date" do
    @log.date.should == Time.mktime(2010, 7, 29)
  end

  it "should return the correct message" do
    should_message = File.read(__FILE__.gsub(/rb$/, "txt"))
    @log.message.should == should_message.gsub(/\r\n/, "\n")
  end
end
