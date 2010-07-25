# encoding: utf-8

unless ENV["GC_USERNAME"] and ENV["GC_PASSWORD"]
  $stderr.puts "You need to provide your geocaching.com account credentials"
  $stderr.puts "by setting the environment variables GC_USERNAME and GC_PASSWORD."
  exit 1
end

begin
  Geocaching::HTTP.login(ENV["GC_USERNAME"], ENV["GC_PASSWORD"])
rescue Geocaching::Error => e
  $stderr.puts "Failed to log in: #{e.message}"
  exit 1
end
