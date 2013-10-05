lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'resque-ar-failover/version'

Gem::Specification.new do |s|
  s.name        = 'resque-ar-failover'
  s.version     = Resque::Plugins::ArFailover::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Pablo Fernandez']
  s.email       = ['heelhook@littleq.net']
  s.homepage    = 'http://github.com/hoteltonight/resque-ar-failover'
  s.summary     = 'Resque plugin to fail over to ActiveRecord backend for Resque job storage, when Redis is unavailable.'
  s.has_rdoc    = false

  s.rubyforge_project = 'resque-ar-failover'

  s.add_dependency 'resque', '~>1.0'
  s.add_dependency 'activerecord', '~>3.2'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'debugger'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ["lib"]
end
