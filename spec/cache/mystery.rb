# encoding: utf-8

describe "Geocaching::Cache for 1d86cace-bada-435a-817a-f841718d7754 (Mystery)" do
  before :all do
    @cache = Geocaching::Cache.fetch(:guid => "1d86cace-bada-435a-817a-f841718d7754")
  end

  it "should return the correct GC code" do
    @cache.code.should == "GC21BBB"
  end

  it "should return the correct ID" do
    @cache.id.should == 1476636
  end

  it "should return the correct name" do
    @cache.name.should == "Nordstadt-Matrix"
  end

  it "should return the correct displayed owner name" do
    @cache.owner_display_name.should == "CachingFoX"
  end

  it "should return the correct owner GUID" do
    @cache.owner.guid == "9c360222-40d7-48be-8dc7-1d4fe5a2d37c"
  end

  it "should return the correct cache type" do
    @cache.type.to_sym.should == :mystery
  end

  it "should return the correct size" do
    @cache.size.should == :small
  end

  it "should return the correct hidden date" do
    @cache.hidden_at.should == Time.mktime(2010, 2, 23)
  end

  it "should return the correct difficulty rating" do
    @cache.difficulty.should == 3.5
  end

  it "should return the correct terrain rating" do
    @cache.terrain.should == 2
  end

  it "should return the correct latitude" do
    @cache.latitude.should == 49.466133
  end

  it "should return the correct longitude" do
    @cache.longitude.should == 11.07135
  end

  it "should return the correct location" do
    @cache.location.should == "Bayern, Germany"
  end

  it "should return a plausible number of logs" do
    @cache.logs.size.should >= 61
  end

  it "should return cache has not been archived" do
    @cache.archived?.should == false
  end

  it "should return cache is not PM-only" do
    @cache.pmonly?.should == false
  end

  it "should return cache is not in review" do
    @cache.in_review?.should == false
  end
end
