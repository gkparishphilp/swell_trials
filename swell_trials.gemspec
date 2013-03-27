$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "swell_trials/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "swell_trials"
  s.version     = SwellTrials::VERSION
  s.authors     = ["Gk Parish-Philp"]
  s.email       = ["gk@gkparishphilp.com"]
  s.homepage    = "http://gkparishphilp.com"
  s.summary     = "A Swell A/B/C Testing framework"
  s.description = "Enables quick testing of multiple pages. Tracks conversions, etc."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency "sqlite3"

  s.add_dependency "rails", "~> 3.2.12"
  s.add_dependency 'statsample'
end
