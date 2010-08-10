# encoding: utf-8

describe "Geocaching::Cache for b60781d0-0933-426d-9a67-80eb855e87ef (Mega Event)" do
  before :all do
    @cache = Geocaching::Cache.fetch(:guid => "b60781d0-0933-426d-9a67-80eb855e87ef")
  end

  it "should return the correct GC code" do
    @cache.code.should == "GC1XEDZ"
  end

  it "should return the correct name" do
    @cache.name.should == "Pinzgau 2010"
  end

  it "should return the correct cache type" do
    @cache.type.to_sym.should == :megaevent
  end

  it "should return the correct size" do
    @cache.size.should == :not_chosen
  end

  it "should return the correct event date" do
    @cache.event_date.should == Time.mktime(2010, 5, 29)
  end

  it "should return the correct difficulty rating" do
    @cache.difficulty.should == 1
  end

  it "should return the correct terrain rating" do
    @cache.terrain.should == 1
  end

  it "should return the correct latitude" do
    @cache.latitude.should == 47.2744
  end

  it "should return the correct longitude" do
    @cache.longitude.should == 12.770883
  end

  it "should return the correct location" do
    @cache.location.should == "Salzburg, Austria"
  end

  it "should return a plausible number of logs" do
    @cache.logs.size.should >= 1783
  end

  it "should return cache has not been archived" do
    @cache.archived?.should == false
  end

  it "should return cache is not PM-only" do
    @cache.pmonly?.should == false
  end
end
