# encoding: utf-8

describe "Geocaching::Cache for 6cea30b1-7279-43ac-86a8-cdfd1daeb348 (Event)" do
  before :all do
    @cache = Geocaching::Cache.fetch(:guid => "6cea30b1-7279-43ac-86a8-cdfd1daeb348")
  end

  it "should return the correct GC code" do
    @cache.code.should == "GC211KT"
  end

  it "should return the correct ID" do
    @cache.id.should == 1467288
  end

  it "should return the correct name" do
    @cache.name.should == "Weihnachtliches Vorglühen"
  end

  it "should return the correct displayed owner name" do
    @cache.owner_display_name.should == "papasid"
  end

  it "should return the correct owner GUID" do
    @cache.owner.guid == "80b63301-073e-4cf7-af23-2fb162915878"
  end

  it "should return the correct cache type" do
    @cache.type.to_sym.should == :event
  end

  it "should return the correct size" do
    @cache.size.should == :not_chosen
  end

  it "should return the correct event date" do
    @cache.event_date.should == Time.mktime(2009, 12, 23)
  end

  it "should return the correct difficulty rating" do
    @cache.difficulty.should == 1
  end

  it "should return the correct terrain rating" do
    @cache.terrain.should == 1
  end

  it "should return the correct latitude" do
    @cache.latitude.should == 49.420667
  end

  it "should return the correct longitude" do
    @cache.longitude.should == 11.1145
  end

  it "should return the correct location" do
    @cache.location.should == "Bayern, Germany"
  end

  it "should return the correct number of logs" do
    @cache.logs.size.should == 69
  end

  it "should return cache has been archived" do
    @cache.archived?.should == true
  end

  it "should return cache is not PM-only" do
    @cache.pmonly?.should == false
  end

  it "should return cache is not in review" do
    @cache.in_review?.should == false
  end
end
