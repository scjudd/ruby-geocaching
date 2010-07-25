# encoding: utf-8

task :default => :test

task :test do
  sh "spec -c -f specdoc spec"
end

task :console do
  sh "irb -I lib -r geocaching"
end
