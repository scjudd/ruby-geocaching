# encoding: utf-8

describe "Geocaching::Log for 6eecdf81-3958-4b93-8d63-24f53107f97a (Owner Maintenance)" do
  before :all do
    @log = Geocaching::Log.fetch(:guid => "6eecdf81-3958-4b93-8d63-24f53107f97a")
  end

  it "should return the correct username" do
    @log.user.name.should == "pöllö"
  end

  it "should return the correct cache GUID" do
    @log.cache.guid.should == "006ceb4e-5a45-471c-a74a-2af0a6035565"
  end

  it "should return the correct type" do
    @log.type.to_sym.should == :owner_maintenance
  end

  it "should return the correct date" do
    @log.date.should == Time.mktime(2009, 11, 26)
  end

  it "should return the correct message" do
    should_message = File.read(__FILE__.gsub(/rb$/, "txt"))
    @log.message.should == should_message.gsub(/\r\n/, "\n")
  end
end
