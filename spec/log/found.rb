# encoding: utf-8

describe "Geocaching::Log for a3237dec-6931-4221-8f00-5d62923b411a (Found it)" do
  before :all do
    @log = Geocaching::Log.fetch(:guid => "a3237dec-6931-4221-8f00-5d62923b411a")
  end

  it "should return the correct username" do
    @log.user.name.should == "CampinCrazy"
  end

  it "should return the correct cache GUID" do
    @log.cache.guid.should == "66274935-40d5-43d8-8cc3-c819e38f9dcc"
  end

  it "should return the correct type" do
    @log.type.to_sym.should == :found
  end

  it "should return the correct date" do
    @log.date.should == Time.mktime(2009, 1, 31)
  end

  it "should return the correct message" do
    should_message = File.read(__FILE__.gsub(/rb$/, "txt"))
    @log.message.should == should_message.gsub(/\r\n/, "\n")
  end
end
