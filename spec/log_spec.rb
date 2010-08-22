# encoding: utf-8

$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
dir = File.dirname(__FILE__)

require "geocaching"
require "#{dir}/helper"

Geocaching::LogType::TYPES.to_a.map { |a| a[0].to_s }.each do |type|
  begin
    require "#{dir}/log/#{type}"
  rescue LoadError
    $stderr.puts "Missing test for log type #{type}"
  end
end
