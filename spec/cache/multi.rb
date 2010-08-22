# encoding: utf-8

describe "Geocaching::Cache for 07cfab08-dadb-4a8f-a187-2a63404b4d3c (Multi)" do
  before :all do
    @cache = Geocaching::Cache.fetch(:guid => "07cfab08-dadb-4a8f-a187-2a63404b4d3c")
  end

  it "should return the correct GC code" do
    @cache.code.should == "GC1V1RH"
  end

  it "should return the correct name" do
    @cache.name.should == "D1 - Plan-les-Ouates - le défi"
  end

  it "should return the correct displayed owner name" do
    @cache.owner_display_name.should == "Dizzione"
  end

  it "should return the correct owner GUID" do
    @cache.owner.guid == "d83598c6-5185-41b5-b4b9-b38c53bcdd2f"
  end

  it "should return the correct cache type" do
    @cache.type.to_sym.should == :multi
  end

  it "should return the correct size" do
    @cache.size.should == :other
  end

  it "should return the correct hidden date" do
    @cache.hidden_at.should == Time.mktime(2009, 6, 23)
  end

  it "should return the correct difficulty rating" do
    @cache.difficulty.should == 2
  end

  it "should return the correct terrain rating" do
    @cache.terrain.should == 1.5
  end

  it "should return the correct latitude" do
    @cache.latitude.should == 46.166233
  end

  it "should return the correct longitude" do
    @cache.longitude.should == 6.119683
  end

  it "should return the correct location" do
    @cache.location.should == "Suisse romande (GE/VD/FR), Switzerland"
  end

  it "should return the correct number of logs" do
    @cache.logs.size.should >= 21
  end

  it "should return cache has not been archived" do
    @cache.archived?.should == false
  end

  it "should return cache is not PM-only" do
    @cache.pmonly?.should == false
  end
end
