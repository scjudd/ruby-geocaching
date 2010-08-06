Gem::Specification.new do |s|
  s.name = "geocaching"
  s.version = "0.2.3"

  s.summary = "API for geocaching.com"
  s.description = "A Ruby library that provides an API for information on geocaching.com"

  s.author = "Thomas Cyron"
  s.email = "nano@fooo.org"
  s.homepage = "http://nano.github.com/ruby-geocaching"

  s.files  = %w(README.markdown Rakefile geocaching.gemspec)
  s.files += Dir.glob("lib/**/*")
  s.files += Dir.glob("spec/**/*")

  s.has_rdoc = false
  s.add_dependency "nokogiri", ">= 1.4.2"
  s.add_development_dependency "rspec"
end
