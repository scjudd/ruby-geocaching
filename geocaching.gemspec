Gem::Specification.new do |s|
  s.name        = "geocaching"
  s.version     = "0.1.0"

  s.summary     = "Library for accessing information on geocaching.com"
  s.description = <<-EOD
A Ruby library that allows to access information on geocaching.com
in an object-oriented manner.
EOD

  s.author      = "nano"
  s.email       = "nano@fooo.org"
  s.homepage    = "http://nano.github.com/geocaching"

  s.has_rdoc    = false
  s.has_yardoc  = true

  s.files       = %w(README.markdown Rakefile geocaching.gemspec)
  s.files      += Dir.glob("lib/**/*")
  s.files      += Dir.glob("spec/**/*")

  s.add_dependency "hpricot", ">= 0.8.2"
end
