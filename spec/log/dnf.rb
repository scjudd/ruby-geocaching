# encoding: utf-8

describe "Geocaching::Log for 08dab41e-feaf-4f24-a9b5-b87e864f385f (Didn't find it)" do
  before :all do
    @log = Geocaching::Log.fetch(:guid => "08dab41e-feaf-4f24-a9b5-b87e864f385f")
  end

  it "should return the correct username" do
    @log.username.should == "swemil"
  end

  it "should return the correct cache GUID" do
    @log.cache.guid.should == "d7524ad9-3c15-451a-9997-6c167f7b406f"
  end

  it "should return the correct type" do
    @log.type.to_sym.should == :dnf
  end

  it "should return the correct date" do
    @log.date.should == Time.mktime(2010, 7, 17)
  end

  it "should return the correct message" do
    should_message = File.read(__FILE__.gsub(/rb$/, "txt"))
    @log.message.should == should_message.gsub(/\r\n/, "\n")
  end
end
