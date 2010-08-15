# encoding: utf-8

describe "Geocaching::Cache for 6128b8a1-2ed3-48f0-9e05-a7117c5faffc (Wherigo)" do
  before :all do
    @cache = Geocaching::Cache.fetch(:guid => "6128b8a1-2ed3-48f0-9e05-a7117c5faffc")
  end

  it "should return the correct GC code" do
    @cache.code.should == "GC19RVP"
  end

  it "should return the correct name" do
    @cache.name.should == "Pegnitztal"
  end

  it "should return the correct displayed owner name" do
    @cache.owner_display_name.should == "OLN"
  end

  it "should return the correct owner GUID" do
    @cache.owner.guid == "969ca2db-d6ed-4e26-a83f-9cf336ff815a"
  end

  it "should return the correct cache type" do
    @cache.type.to_sym.should == :wherigo
  end

  it "should return the correct size" do
    @cache.size.should == :small
  end

  it "should return the correct hidden date" do
    @cache.hidden_at.should == Time.mktime(2008, 2, 29)
  end

  it "should return the correct difficulty rating" do
    @cache.difficulty.should == 1.5
  end

  it "should return the correct terrain rating" do
    @cache.terrain.should == 1.5
  end

  it "should return the correct latitude" do
    @cache.latitude.should == 49.466333
  end

  it "should return the correct longitude" do
    @cache.longitude.should == 11.147267
  end

  it "should return the correct location" do
    @cache.location.should == "Bayern, Germany"
  end

  it "should return a plausible number of logs" do
    @cache.logs.size.should >= 182
  end

  it "should return cache has not been archived" do
    @cache.archived?.should == false
  end

  it "should return cache is not PM-only" do
    @cache.pmonly?.should == false
  end
end
