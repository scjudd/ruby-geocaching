# encoding: utf-8

describe "Geocaching::Cache for c52ff346-4567-4865-a230-c136843049e5 (CITO)" do
  before :all do
    @cache = Geocaching::Cache.fetch(:guid => "c52ff346-4567-4865-a230-c136843049e5")
  end

  it "should return the correct GC code" do
    @cache.code.should == "GC1W95B"
  end

  it "should return the correct ID" do
    @cache.id.should == 1325573
  end

  it "should return the correct name" do
    @cache.name.should == "1. Dresdner CITO"
  end

  it "should return the correct displayed owner name" do
    @cache.owner_display_name.should == "GPS-Murmel, afrineo, Karrataka"
  end

  it "should return the correct owner GUID" do
    @cache.owner.guid == "b2fcf494-ecb8-4862-a279-03a325f6e1a1"
  end

  it "should return the correct cache type" do
    @cache.type.to_sym.should == :cito
  end

  it "should return the correct size" do
    @cache.size.should == :not_chosen
  end

  it "should return the correct event date" do
    @cache.event_date.should == Time.mktime(2010, 4, 17)
  end

  it "should return the correct difficulty rating" do
    @cache.difficulty.should == 2.5
  end

  it "should return the correct terrain rating" do
    @cache.terrain.should == 4.5
  end

  it "should return the correct latitude" do
    @cache.latitude.should == 51.066667
  end

  it "should return the correct longitude" do
    @cache.longitude.should == 13.728333
  end

  it "should return the correct location" do
    @cache.location.should == "Sachsen, Germany"
  end

  it "should return a plausible number of logs" do
    @cache.logs.size.should >= 337
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
