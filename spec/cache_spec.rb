# encoding: utf-8

$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
dir = File.dirname(__FILE__)

require "geocaching"
require "#{dir}/helper"

Geocaching::CacheType::TYPES.to_a.map { |a| a[0].to_s }.each do |type|
  # Locationless caches have completely been disabled on geocaching.com
  next if type == "locationless"

  require "#{dir}/cache/#{type}"
end
