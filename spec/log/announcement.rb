# encoding: utf-8

describe "Geocaching::Log for 37ef1827-17a6-436c-b8a1-01f1573186f3 (Announcement)" do
  before :all do
    @log = Geocaching::Log.fetch(:guid => "37ef1827-17a6-436c-b8a1-01f1573186f3")
  end

  it "should return the correct username" do
    @log.username.should == "Frank Frank"
  end

  it "should return the correct cache GUID" do
    @log.cache.guid.should == "7fb096e6-bd69-4e48-8665-9316852960a0"
  end

  it "should return the correct type" do
    @log.type.to_sym.should == :announcement
  end

  it "should return the correct date" do
    @log.date.should == Time.mktime(2010, 8, 7)
  end

  it "should return the correct message" do
    should_message = File.read(__FILE__.gsub(/rb$/, "txt"))
    @log.message.should == should_message.gsub(/\r\n/, "\n")
  end
end
