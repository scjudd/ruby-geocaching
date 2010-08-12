# encoding: utf-8

describe "Geocaching::Log for d7ae038b-cb26-4b8e-bcca-5effd05870d0 (Publish)" do
  before :all do
    @log = Geocaching::Log.fetch(:guid => "d7ae038b-cb26-4b8e-bcca-5effd05870d0")
  end

  it "should return the correct username" do
    @log.username.should == "geoawareCA"
  end

  it "should return the correct cache GUID" do
    @log.cache.guid.should == "d4c5b818-1d91-4c01-a305-7c9950ec57f2"
  end

  it "should return the correct type" do
    @log.type.to_sym.should == :publish
  end

  it "should return the correct date" do
    @log.date.should == Time.mktime(2010, 4, 11)
  end

  it "should return the correct message" do
    should_message = File.read(__FILE__.gsub(/rb$/, "txt"))
    @log.message.should == should_message.gsub(/\r\n/, "\n")
  end
end
