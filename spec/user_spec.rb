# encoding: utf-8

$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require "geocaching"
require "helper"

describe "Geocaching::User for efa09aeb-e2ac-4aad-8779-725a4aa35eac" do
  before :all do
    @user = Geocaching::User.fetch(:guid => "efa09aeb-e2ac-4aad-8779-725a4aa35eac")
  end

  it "should return the correct GUID" do
    @user.guid.should == "efa09aeb-e2ac-4aad-8779-725a4aa35eac"
  end

  it "should return the correct user name" do
    @user.name.should == "palmetto"
  end

  it "should return the correct member since date" do
    @user.member_since.should == Time.mktime(2005, 12, 5)
  end

  it "should return a plausible last visit date" do
    @user.last_visit.should >= Time.mktime(2010, 8, 12)
  end

  it "should return the correct occupation" do
    @user.occupation.should == "loafering"
  end

  it "should return the correct location" do
    @user.location.should == "sunny Florida"
  end

  it "should return no homepage" do
    @user.homepage.should == nil
  end

  it "should return user is a premium member" do
    @user.premium_member?.should == true
  end

  it "should return user is a reviewer" do
    @user.reviewer?.should == true
  end
end
