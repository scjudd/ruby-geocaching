# encoding: utf-8

describe "Geocaching::Cache for 4ee2c3a1-96e3-4ce0-ad2b-094a51cb3f46 (Multi)" do
  before :all do
    @cache = Geocaching::Cache.fetch(:guid => "4ee2c3a1-96e3-4ce0-ad2b-094a51cb3f46")
  end

  it "should return the correct GC code" do
    @cache.code.should == "GCKZ6J"
  end

  it "should return the correct name" do
    @cache.name.should == "MITTELERDE I - DUESTERWALD"
  end

  it "should return the correct displayed owner name" do
    @cache.owner_display_name.should == "123MAINE"
  end

  it "should return the correct owner GUID" do
    @cache.owner.guid == "50da2530-3756-4eb9-9af4-429fb998be3c"
  end

  it "should return the correct cache type" do
    @cache.type.to_sym.should == :multi
  end

  it "should return the correct size" do
    @cache.size.should == :regular
  end

  it "should return the correct hidden date" do
    @cache.hidden_at.should == Time.mktime(2004, 10, 31)
  end

  it "should return the correct difficulty rating" do
    @cache.difficulty.should == 3
  end

  it "should return the correct terrain rating" do
    @cache.terrain.should == 3.5
  end

  it "should return the correct latitude" do
    @cache.latitude.should == 49.570583
  end

  it "should return the correct longitude" do
    @cache.longitude.should == 11.122083
  end

  it "should return the correct location" do
    @cache.location.should == "Bayern, Germany"
  end

  it "should return the correct number of logs" do
    @cache.logs.size.should == 504
  end

  it "should return cache has been archived" do
    @cache.archived?.should == true
  end

  it "should return cache is not PM-only" do
    @cache.pmonly?.should == false
  end
end