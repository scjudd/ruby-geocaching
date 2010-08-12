# encoding: utf-8

describe "Geocaching::Cache for 7d120ae2-855c-430d-9c14-3d7427de4bdd (Project A.P.E. Cache)" do
  before :all do
    @cache = Geocaching::Cache.fetch(:guid => "7d120ae2-855c-430d-9c14-3d7427de4bdd")
  end

  it "should return the correct GC code" do
    @cache.code.should == "GC1169"
  end

  it "should return the correct name" do
    @cache.name.should == "Mission 9: Tunnel of Light"
  end

  it "should return the correct cache type" do
    @cache.type.to_sym.should == :ape
  end

  it "should return the correct size" do
    @cache.size.should == :large
  end

  it "should return the correct hidden date" do
    @cache.hidden_at.should == Time.mktime(2001, 7, 18)
  end

  it "should return the correct difficulty rating" do
    @cache.difficulty.should == 1
  end

  it "should return the correct terrain rating" do
    @cache.terrain.should == 3
  end

  it "should return the correct latitude" do
    @cache.latitude.should == 47.3919
  end

  it "should return the correct longitude" do
    @cache.longitude.should == -121.455083
  end

  it "should return the correct location" do
    @cache.location.should == "Washington, United States"
  end

  it "should return a plausible number of logs" do
    @cache.logs.size.should >= 3566
  end

  it "should return cache has not been archived" do
    @cache.archived?.should == false
  end

  it "should return cache is not PM-only" do
    @cache.pmonly?.should == false
  end
end
