# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'slammer/version'

Gem::Specification.new do |s|
  s.name        = 'slammer'
  s.version     = '4.0.3'
  s.authors     = ['Peter Alcock']
  s.email       = ['peter.alcock@eclecticlabs.com']
  s.homepage    = 'http://eclecticlabs.com/'
  s.summary     = 'Provides mechanism to use ActiveRecord as an authenticator for Slammer.'
  s.description = 'This gem can be used to allow the Slammer backend to authenticate against an SQL server using ActiveRecord.'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  sign_file = File.expand_path '~/.gem/slammer-private_key.pem'
  if File.exist?(sign_file)
    s.signing_key = sign_file
    s.cert_chain  = ['slammer-public_cert.pem']
  end

  s.add_development_dependency 'capybara', '~> 2.1'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'rspec-its', '~> 1.0'
  s.add_development_dependency 'rspec-rails', '~> 3.0'
  s.add_development_dependency 'sqlite3', '~> 1.3'
  s.add_development_dependency 'factory_girl', '~> 4.1'
  s.add_development_dependency 'webmock', '~> 1.9'
  s.add_development_dependency 'coveralls', '~> 0.7'

  s.add_runtime_dependency 'rails', '>= 4.1.0', '< 4.3.0'
  s.add_runtime_dependency 'sass-rails', '>= 4.0.0', '< 6.0.0'
  s.add_runtime_dependency 'addressable', '~> 2.3'
  s.add_runtime_dependency 'terminal-table', '~> 1.4'
  s.add_runtime_dependency 'useragent', '~> 0.4'
  s.add_runtime_dependency 'faraday', '~> 0.8'
  s.add_runtime_dependency 'rotp', '~> 2.0'
  s.add_runtime_dependency 'grape', '~> 0.8'
  s.add_runtime_dependency 'grape-entity', '~> 0.4'
  s.add_runtime_dependency 'rqrcode_png', '~> 0.1'
end
