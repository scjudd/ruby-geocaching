# encoding: utf-8

describe "Geocaching::Log for c7f88568-9417-45c2-9906-c4f0210c7837 (Webcam Photo Taken)" do
  before :all do
    @log = Geocaching::Log.fetch(:guid => "c7f88568-9417-45c2-9906-c4f0210c7837")
  end

  it "should return the correct username" do
    @log.username.should == "123flash"
  end

  it "should return the correct cache GUID" do
    @log.cache.guid.should == "ed19825b-f94d-450f-a1df-feb274f33ac8"
  end

  it "should return the correct type" do
    @log.type.to_sym.should == :webcam_photo_taken
  end

  it "should return the correct date" do
    @log.date.should == Time.mktime(2010, 6, 30)
  end

  it "should return the correct message" do
    should_message = File.read(__FILE__.gsub(/rb$/, "txt"))
    @log.message.should == should_message.gsub(/\r\n/, "\n")
  end
end
