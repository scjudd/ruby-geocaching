# encoding: utf-8

describe "Geocaching::Log for 48a90293-e589-4690-bdcc-de0043d79b6d (Archive)" do
  before :all do
    @log = Geocaching::Log.fetch(:guid => "48a90293-e589-4690-bdcc-de0043d79b6d")
  end

  it "should return the correct username" do
    @log.user.name.should == "jonny42"
  end

  it "should return the correct cache GUID" do
    @log.cache.guid.should == "24edb0c6-cc83-477c-b0b9-78716d43a8dc"
  end

  it "should return the correct type" do
    @log.type.to_sym.should == :archive
  end

  it "should return the correct date" do
    @log.date.should == Time.mktime(2010, 7, 5)
  end

  it "should return the correct message" do
    should_message = File.read(__FILE__.gsub(/rb$/, "txt"))
    @log.message.should == should_message.gsub(/\r\n/, "\n")
  end
end
