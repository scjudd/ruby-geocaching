# encoding: utf-8

describe "Geocaching::Log for 9bf458db-6dc9-4e02-b7ea-9cf056c40ade (Attended)" do
  before :all do
    @log = Geocaching::Log.fetch(:guid => "9bf458db-6dc9-4e02-b7ea-9cf056c40ade")
  end

  it "should return the correct username" do
    @log.username.should == "Snooking Good"
  end

  it "should return the correct cache GUID" do
    @log.cache.guid.should == "2f067ddb-1999-403a-8f9f-7509b8a68494"
  end

  it "should return the correct type" do
    @log.type.to_sym.should == :attended
  end

  it "should return the correct date" do
    @log.date.should == Time.mktime(2010, 8, 8)
  end

  it "should return the correct message" do
    should_message = File.read(__FILE__.gsub(/rb$/, "txt"))
    @log.message.should == should_message.gsub(/\r\n/, "\n")
  end
end
