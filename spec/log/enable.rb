# encoding: utf-8

describe "Geocaching::Log for 4e588373-768d-43fb-8cf1-45d2a7d21599 (Enable Listing)" do
  before :all do
    @log = Geocaching::Log.fetch(:guid => "4e588373-768d-43fb-8cf1-45d2a7d21599")
  end

  it "should return the correct username" do
    @log.username.should == "Cermak"
  end

  it "should return the correct cache GUID" do
    @log.cache.guid.should == "66274935-40d5-43d8-8cc3-c819e38f9dcc"
  end

  it "should return the correct type" do
    @log.type.to_sym.should == :enable
  end

  it "should return the correct date" do
    @log.date.should == Time.mktime(2009, 1, 1)
  end

  it "should return the correct message" do
    should_message = File.read(__FILE__.gsub(/rb$/, "txt"))
    @log.message.should == should_message.gsub(/\r\n/, "\n")
  end
end
