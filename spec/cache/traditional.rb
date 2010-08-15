# encoding: utf-8

describe "Geocaching::Cache for 66274935-40d5-43d8-8cc3-c819e38f9dcc (Traditional)" do
  before :all do
    @cache = Geocaching::Cache.fetch(:guid => "66274935-40d5-43d8-8cc3-c819e38f9dcc")
  end

  it "should return the correct GC code" do
    @cache.code.should == "GCF00"
  end

  it "should return the correct name" do
    @cache.name.should == "Bridge Over Troubled Waters"
  end

  it "should return the correct displayed owner name" do
    @cache.owner_display_name.should == "Cermak"
  end

  it "should return the correct owner GUID" do
    @cache.owner.guid == "07eae57b-a6c2-4a8d-a1c9-667c63dccfca"
  end

  it "should return the correct cache type" do
    @cache.type.to_sym.should == :traditional
  end

  it "should return the correct size" do
    @cache.size.should == :regular
  end

  it "should return the correct hidden date" do
    @cache.hidden_at.should == Time.mktime(2001, 07, 05)
  end

  it "should return the correct difficulty rating" do
    @cache.difficulty.should == 2.5
  end

  it "should return the correct terrain rating" do
    @cache.terrain.should == 1.5
  end

  it "should return the correct latitude" do
    @cache.latitude.should == 32.6684
  end

  it "should return the correct longitude" do
    @cache.longitude.should == -97.436783
  end

  it "should return the correct location" do
    @cache.location.should == "Texas, United States"
  end

  it "should return a plausible number of logs" do
    @cache.logs.size.should >= 230
  end

  it "should return cache has not been archived" do
    @cache.archived?.should == false
  end

  it "should return cache is not PM-only" do
    @cache.pmonly?.should == false
  end
end
