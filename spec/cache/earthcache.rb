# encoding: utf-8

describe "Geocaching::Cache for e34a5b69-51a1-4ed4-838d-e3c3cb75a35a (EarthCache)" do
  before :all do
    @cache = Geocaching::Cache.fetch(:guid => "e34a5b69-51a1-4ed4-838d-e3c3cb75a35a")
  end

  it "should return the correct GC code" do
    @cache.code.should == "GC26Y3T"
  end

  it "should return the correct ID" do
    @cache.id.should == 1642655
  end

  it "should return the correct name" do
    @cache.name.should == "Kniepsand Amrum (Earthcache)"
  end

  it "should return the correct displayed owner name" do
    @cache.owner_display_name.should == "Ifranipop"
  end

  it "should return the correct owner GUID" do
    @cache.owner.guid == "4fcca7ab-b4c7-42ee-86d6-c61056a9263e"
  end

  it "should return the correct cache type" do
    @cache.type.to_sym.should == :earthcache
  end

  it "should return the correct size" do
    @cache.size.should == :not_chosen
  end

  it "should return the correct hidden date" do
    @cache.hidden_at.should == Time.mktime(2010, 4, 17)
  end

  it "should return the correct difficulty rating" do
    @cache.difficulty.should == 2
  end

  it "should return the correct terrain rating" do
    @cache.terrain.should == 2
  end

  it "should return the correct latitude" do
    @cache.latitude.should == 54.64475
  end

  it "should return the correct longitude" do
    @cache.longitude.should == 8.321667
  end

  it "should return the correct location" do
    @cache.location.should == "Schleswig-Holstein, Germany"
  end

  it "should return the correct number of logs" do
    @cache.logs.size.should >= 57
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
