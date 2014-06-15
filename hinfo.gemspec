# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hinfo/version'

Gem::Specification.new do |gem|
  gem.name          = 'hinfo'
  gem.license       = 'MIT'
  gem.version       = Hinfo::VERSION
  gem.authors       = ['bqbn']
  gem.email         = ['bqbn@openken.com']
  gem.summary       = 'hinfo is a simple service that returns facts '\
                      'about the running h to its querier. hinfo '\
                      'leverages facter and sinatra to achieve its purpose.'
  gem.homepage      = 'https://github.com/bqbn/hinfo'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.required_ruby_version = '>= 1.9.3'
  gem.add_dependency('sinatra', '>= 1.4.3')
  gem.add_dependency('facter', '>= 1.7.3')
  gem.add_dependency('daemons', '>= 1.1.9')
end

# vim: set et ts=2 sts=2 sw=2 si sta :
