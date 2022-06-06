# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'slammer/ldap_authenticator/version'

Gem::Specification.new do |s|
  s.name        = 'slammer-ldap_authenticator'
  s.version     = Slammer::LDAPAuthenticator::VERSION
  s.authors     = ['Peter Alcock']
  s.email       = ['peter.alcock@eclecticlabs.com']
  s.homepage    = 'http://eclecticlabs.com/'
  s.summary     = 'Provides mechanism to use ActiveRecord as an authenticator for Slammer.'
  s.description = 'This gem can be used to allow the Slammer backend to authenticate against an LDAP server using ActiveRecord.'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'rspec', '~> 2.12'
  s.add_development_dependency 'simplecov', '~> 0.7'
  s.add_development_dependency 'coveralls'

  s.add_runtime_dependency 'net-ldap', '~> 0.3'
  s.add_runtime_dependency 'slammer', '>= 3.0.0', '< 5.0.0'
end
