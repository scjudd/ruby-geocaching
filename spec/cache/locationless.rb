# encoding: utf-8

describe "Geocaching::Cache for 9ce22167-5a8d-451c-a69b-b19d5ec4f578 (Locationless)" do
  before :all do
    @cache = Geocaching::Cache.fetch(:guid => "9ce22167-5a8d-451c-a69b-b19d5ec4f578")
  end

  it "should return the correct GC code" do
    @cache.code.should == "GCB48F"
  end

  it "should return the correct ID" do
    @cache.id.should == 46223
  end

  it "should return the correct name" do
    @cache.name.should == "die letzte ihrer art?"
  end

  it "should return the correct displayed owner name" do
    @cache.owner_display_name.should == "alexem+sonja+der rote elephant"
  end

  it "should return the correct owner GUID" do
    @cache.owner.guid == "87709ecd-09da-44d7-abc3-1ef36921f8e7"
  end

  it "should return the correct cache type" do
    @cache.type.to_sym.should == :locationless
  end

  it "should return the correct size" do
    @cache.size.should == :virtual
  end

  it "should return the correct hidden date" do
    @cache.hidden_at.should == Time.mktime(2002, 12, 14)
  end

  it "should return the correct difficulty rating" do
    @cache.difficulty.should == 2.5
  end

  it "should return the correct terrain rating" do
    @cache.terrain.should == 2.5
  end

  it "should return no latitude" do
    @cache.latitude.should == nil
  end

  it "should return no longitude" do
    @cache.longitude.should == nil
  end

  it "should return no location" do
    @cache.location.should == nil
  end

  it "should return the correct number of logs" do
    @cache.logs.size.should == 1330
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
