# -*- encoding: utf-8 -*-
require File.expand_path('../lib/cupid/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "cupid"
  s.authors     = ['gazay', 'brainopia']
  s.email       = ['gazay@evilmartians.com']
  s.homepage    = "http://github.com/evilmartians/cupid"
  s.summary     = "Create, organize and send emails through Exact Target SOAP API"
  s.description = "Send love, not war. This version of cupid works with ET SOAP API s4."

  s.add_dependency "builder",   ">= 2.1.2"
  s.add_dependency "nokogiri",  ">= 1.4.1"
  s.add_dependency "savon",     ">= 0.9.0"

  s.add_development_dependency "rspec", "~> 2"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.version     = Cupid::VERSION
end
