# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cupid/version"

Gem::Specification.new do |s|
  s.name        = "cupid"
  s.version     = Cupid::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['gazay']
  s.email       = ['gazay@evilmartians.com']
  s.homepage    = ""
  s.summary     = %q{Create, organize and send emails through Exact Target SOAP API}
  s.description = %q{Send love, not war. This version of cupid can only work with ET SOAP API with s4.}

  s.rubyforge_project = "cupid"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
