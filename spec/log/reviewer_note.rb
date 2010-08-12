# encoding: utf-8

describe "Geocaching::Log for 876d4e85-ebe9-4098-8552-151f34d3b4de (Post Reviewer Note)" do
  before :all do
    @log = Geocaching::Log.fetch(:guid => "876d4e85-ebe9-4098-8552-151f34d3b4de")
  end

  it "should return the correct username" do
    @log.username.should == "Prime Reviewer"
  end

  it "should return the correct cache GUID" do
    @log.cache.guid.should == "66274935-40d5-43d8-8cc3-c819e38f9dcc"
  end

  it "should return the correct type" do
    @log.type.to_sym.should == :reviewer_note
  end

  it "should return the correct date" do
    @log.date.should == Time.mktime(2010, 7, 8)
  end

  it "should return the correct message" do
    should_message = File.read(__FILE__.gsub(/rb$/, "txt"))
    @log.message.should == should_message.gsub(/\r\n/, "\n")
  end
end
