# encoding: utf-8

describe "Geocaching::Cache for 4e8b79e1-ffb2-4845-9c24-5ef54137a9b9 (Virtual)" do
  before :all do
    @cache = Geocaching::Cache.fetch(:guid => "4e8b79e1-ffb2-4845-9c24-5ef54137a9b9")
  end

  it "should return the correct GC code" do
    @cache.code.should == "GCEB74"
  end

  it "should return the correct name" do
    @cache.name.should == "Buecherturm"
  end

  it "should return the correct displayed owner name" do
    @cache.owner_display_name.should == "cosmic bob"
  end

  it "should return the correct owner GUID" do
    @cache.owner.guid == "176be429-73f6-4812-99b0-aec77ee754d8"
  end

  it "should return the correct cache type" do
    @cache.type.to_sym.should == :virtual
  end

  it "should return the correct size" do
    @cache.size.should == :virtual
  end

  it "should return the correct hidden date" do
    @cache.hidden_at.should == Time.mktime(2003, 3, 24)
  end

  it "should return the correct difficulty rating" do
    @cache.difficulty.should == 3
  end

  it "should return the correct terrain rating" do
    @cache.terrain.should == 1
  end

  it "should return the correct latitude" do
    @cache.latitude.should == 53.553067
  end

  it "should return the correct longitude" do
    @cache.longitude.should == 10.006933
  end

  it "should return the correct location" do
    @cache.location.should == "Hamburg, Germany"
  end

  it "should return a plausible number of logs" do
    @cache.logs.size.should >= 856
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
