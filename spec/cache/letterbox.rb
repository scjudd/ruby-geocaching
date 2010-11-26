# encoding: utf-8

describe "Geocaching::Cache for 01328a57-5a04-4e69-a1cc-ce0eeaa452f5 (Letterbox)" do
  before :all do
    @cache = Geocaching::Cache.fetch(:guid => "01328a57-5a04-4e69-a1cc-ce0eeaa452f5")
  end

  it "should return the correct GC code" do
    @cache.code.should == "GC1KBJD"
  end

  it "should return the correct ID" do
    @cache.id.should == 1089572
  end

  it "should return the correct name" do
    @cache.name.should == "Worzeldorfer Gebirge (Letterbox)"
  end

  it "should return the correct displayed owner name" do
    @cache.owner_display_name.should == "numakeh (location by gsteinacher)"
  end

  it "should return the correct owner GUID" do
    @cache.owner.guid == "d60bf869-8cc2-4e38-a349-9423f7d65427"
  end

  it "should return the correct cache type" do
    @cache.type.to_sym.should == :letterbox
  end

  it "should return the correct size" do
    @cache.size.should == :regular
  end

  it "should return the correct hidden date" do
    @cache.hidden_at.should == Time.mktime(2009, 1, 3)
  end

  it "should return the correct difficulty rating" do
    @cache.difficulty.should == 3
  end

  it "should return the correct terrain rating" do
    @cache.terrain.should == 3
  end

  it "should return the correct latitude" do
    @cache.latitude.should == 49.370417
  end

  it "should return the correct longitude" do
    @cache.longitude.should == 11.116
  end

  it "should return the correct location" do
    @cache.location.should == "Bayern, Germany"
  end

  it "should return the correct number of logs" do
    @cache.logs.size.should >= 100
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
