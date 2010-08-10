# encoding: utf-8

$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require "geocaching"
require "helper"

Geocaching::CacheType::TYPES.to_a.map { |a| a[0].to_s }.each do |type|
  require "cache/#{type}"
end
