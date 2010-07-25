# encoding: utf-8

$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require "geocaching"
require "helper"

share_as :GCF00 do
  it "should return the correct GC code" do
    @cache.code.should == "GCF00"
  end

  it "should return the correct GUID" do
    @cache.guid.should == "66274935-40d5-43d8-8cc3-c819e38f9dcc"
  end

  it "should return correct cache type ID" do
    @cache.type_id.should == 2
  end

  it "should return the correct name" do
    @cache.name.should == "Bridge Over Troubled Waters"
  end

  it "should return the correct latitude" do
    @cache.latitude.should == 32.6684
  end

  it "should return the correct longitude" do
    @cache.longitude.should == -97.436783
  end

  it "should return the correct difficulty rating" do
    @cache.difficulty.should == 2.5
  end

  it "should return the correct terrain rating" do
    @cache.terrain.should == 1.5
  end

  it "should return the correct hidden at date" do
    @cache.hidden_at.should == Time.parse("2001-07-05")
  end

  it "should return the correct location" do
    @cache.location.should == "Texas, United States"
  end

  it "should say cache is not archived" do
    @cache.archived?.should == false
  end

  it "should say cache is not PM-only" do
    @cache.pmonly?.should == false
  end

  it "should return a plausible number of total logs" do
    @cache.logs.size.should >= 230
  end
end

describe "Geocaching::Cache for GCF00" do
  before :all do
    @cache = Geocaching::Cache.fetch(:code => "GCF00")
  end

  include GCF00
end

describe "Geocaching::Cache for 66274935-40d5-43d8-8cc3-c819e38f9dcc" do
  before :all do
    @cache = Geocaching::Cache.fetch(:guid => "66274935-40d5-43d8-8cc3-c819e38f9dcc")
  end

  include GCF00
end
