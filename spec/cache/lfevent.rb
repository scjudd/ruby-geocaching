# encoding: utf-8

describe "Geocaching::Cache for 32512f3a-0fc2-45df-943b-af0a6f17f1fa (Lost and Found Event)" do
  before :all do
    @cache = Geocaching::Cache.fetch(:guid => "32512f3a-0fc2-45df-943b-af0a6f17f1fa")
  end

  it "should return the correct GC code" do
    @cache.code.should == "GC2546Y"
  end

  it "should return the correct name" do
    @cache.name.should == "10 Jahre! Nürnberg, Germany"
  end

  it "should return the correct displayed owner name" do
    @cache.owner_display_name.should == "team-noris"
  end

  it "should return the correct owner GUID" do
    @cache.owner.guid == "c3d17887-2925-4ff0-9fa6-dccb86d48d3f"
  end

  it "should return the correct cache type" do
    @cache.type.to_sym.should == :lfevent
  end

  it "should return the correct size" do
    @cache.size.should == :not_chosen
  end

  it "should return the correct event date" do
    @cache.event_date.should == Time.mktime(2010, 5, 1)
  end

  it "should return the correct difficulty rating" do
    @cache.difficulty.should == 2
  end

  it "should return the correct terrain rating" do
    @cache.terrain.should == 5
  end

  it "should return the correct latitude" do
    @cache.latitude.should == 49.35475
  end

  it "should return the correct longitude" do
    @cache.longitude.should == 11.20695
  end

  it "should return the correct location" do
    @cache.location.should == "Bayern, Germany"
  end

  it "should return the correct number of logs" do
    @cache.logs.size.should == 118
  end

  it "should return cache has been archived" do
    @cache.archived?.should == true
  end

  it "should return cache is not PM-only" do
    @cache.pmonly?.should == false
  end
end
