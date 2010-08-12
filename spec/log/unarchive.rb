# encoding: utf-8

describe "Geocaching::Log for b70042d7-1411-4f56-950e-d23303e7ab4e (Unarchive)" do
  before :all do
    @log = Geocaching::Log.fetch(:guid => "b70042d7-1411-4f56-950e-d23303e7ab4e")
  end

  it "should return the correct username" do
    @log.username.should == "Krypton"
  end

  it "should return the correct cache GUID" do
    @log.cache.guid.should == "4d56861e-2779-4b2c-b06a-5bbea2ec93d4"
  end

  it "should return the correct type" do
    @log.type.to_sym.should == :unarchive
  end

  it "should return the correct date" do
    @log.date.should == Time.mktime(2009, 1, 16)
  end

  it "should return the correct message" do
    should_message = File.read(__FILE__.gsub(/rb$/, "txt"))
    @log.message.should == should_message.gsub(/\r\n/, "\n")
  end
end
