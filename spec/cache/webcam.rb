# encoding: utf-8

describe "Geocaching::Cache for 8cd0976c-42cf-40a2-ae02-ed87ad52d5b1 (Webcam)" do
  before :all do
    @cache = Geocaching::Cache.fetch(:guid => "8cd0976c-42cf-40a2-ae02-ed87ad52d5b1")
  end

  it "should return the correct GC code" do
    @cache.code.should == "GCQG38"
  end

  it "should return the correct name" do
    @cache.name.should == "Versteckte Kamera"
  end

  it "should return the correct displayed owner name" do
    @cache.owner_display_name.should == "buddler"
  end

  it "should return the correct owner GUID" do
    @cache.owner.guid == "aa82755c-0ee2-4b7b-8e1c-53217cd5b446"
  end

  it "should return the correct cache type" do
    @cache.type.to_sym.should == :webcam
  end

  it "should return the correct size" do
    @cache.size.should == :not_chosen
  end

  it "should return the correct hidden date" do
    @cache.hidden_at.should == Time.mktime(2005, 9, 9)
  end

  it "should return the correct difficulty rating" do
    @cache.difficulty.should == 1.5
  end

  it "should return the correct terrain rating" do
    @cache.terrain.should == 1
  end

  it "should return the correct latitude" do
    @cache.latitude.should == 49.441
  end

  it "should return the correct longitude" do
    @cache.longitude.should == 11.1065
  end

  it "should return the correct location" do
    @cache.location.should == "Bayern, Germany"
  end

  it "should return the correct number of logs" do
    @cache.logs.size.should == 85
  end

  it "should return cache has been archived" do
    @cache.archived?.should == true
  end

  it "should return cache is not PM-only" do
    @cache.pmonly?.should == false
  end
end
