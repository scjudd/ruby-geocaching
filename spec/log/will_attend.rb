# encoding: utf-8

describe "Geocaching::Log for 4ef9383c-19b6-41d6-843e-31ada8abbc22 (Will Attend)" do
  before :all do
    @log = Geocaching::Log.fetch(:guid => "4ef9383c-19b6-41d6-843e-31ada8abbc22")
  end

  it "should return the correct username" do
    @log.username.should == "Dennis the Menace2"
  end

  it "should return the correct cache GUID" do
    @log.cache.guid.should == "2f067ddb-1999-403a-8f9f-7509b8a68494"
  end

  it "should return the correct type" do
    @log.type.to_sym.should == :will_attend
  end

  it "should return the correct date" do
    @log.date.should == Time.mktime(2010, 7, 30)
  end

  it "should return the correct message" do
    should_message = File.read(__FILE__.gsub(/rb$/, "txt"))
    @log.message.should == should_message.gsub(/\r\n/, "\n")
  end
end
