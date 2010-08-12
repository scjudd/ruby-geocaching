# encoding: utf-8

describe "Geocaching::Log for 6802b623-f02c-4268-8fb3-7194ea60a686 (Update Coordinates)" do
  before :all do
    @log = Geocaching::Log.fetch(:guid => "6802b623-f02c-4268-8fb3-7194ea60a686")
  end

  it "should return the correct username" do
    @log.username.should == "Rudisucht"
  end

  it "should return the correct cache GUID" do
    @log.cache.guid.should == "c72dc03a-cd9d-4ebe-9cd2-6789aaa66ae5"
  end

  it "should return the correct type" do
    @log.type.to_sym.should == :coords_update
  end

  it "should return the correct date" do
    @log.date.should == Time.mktime(2009, 5, 15)
  end

  it "should return the correct message" do
    should_message = File.read(__FILE__.gsub(/rb$/, "txt"))
    @log.message.should == should_message.gsub(/\r\n/, "\n")
  end
end
