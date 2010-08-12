# encoding: utf-8

describe "Geocaching::Log for a572c594-8763-408a-9bec-f29b77a1e50f (Needs Maintenance)" do
  before :all do
    @log = Geocaching::Log.fetch(:guid => "a572c594-8763-408a-9bec-f29b77a1e50f")
  end

  it "should return the correct username" do
    @log.username.should == "taroh"
  end

  it "should return the correct cache GUID" do
    @log.cache.guid.should == "c889a2e8-4d15-4b06-997e-8827896de5e8"
  end

  it "should return the correct type" do
    @log.type.to_sym.should == :needs_maintenance
  end

  it "should return the correct date" do
    @log.date.should == Time.mktime(2010, 7, 27)
  end

  it "should return the correct message" do
    should_message = File.read(__FILE__.gsub(/rb$/, "txt"))
    @log.message.should == should_message.gsub(/\r\n/, "\n")
  end
end
