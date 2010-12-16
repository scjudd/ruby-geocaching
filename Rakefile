# encoding: utf-8

task :default => :test

task :test do
  sh "bundle exec rspec -c spec"
end

task :console do
  sh "irb -I lib -r geocaching"
end
