# encoding: utf-8

describe "Geocaching::Log for 1eb67c1f-610d-4d1d-9703-10b3e47416e2 (Write Note)" do
  before :all do
    @log = Geocaching::Log.fetch(:guid => "1eb67c1f-610d-4d1d-9703-10b3e47416e2")
  end

  it "should return the correct username" do
    @log.user.name.should == "cache-strapped"
  end

  it "should return the correct cache GUID" do
    @log.cache.guid.should == "879ec54c-3c0b-4378-bc4c-53c191e17816"
  end

  it "should return the correct type" do
    @log.type.to_sym.should == :note
  end

  it "should return the correct date" do
    @log.date.should == Time.mktime(2005, 6, 5)
  end

  it "should return the correct message" do
    should_message = File.read(__FILE__.gsub(/rb$/, "txt"))
    @log.message.should == should_message.gsub(/\r\n/, "\n")
  end
end
