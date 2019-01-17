# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'userstack/version'

Gem::Specification.new do |spec|
  spec.name          = 'userstack'
  spec.version       = Userstack::VERSION
  spec.authors       = ['Masaki Maeda']
  spec.email         = ['m-maeda@feedforce.jp']

  spec.summary       = 'Ruby toolkit for working with the Userstack'
  spec.description   = 'Simple wrapper for the Userstack API https://userstack.com'
  spec.homepage      = 'https://github.com/feedforce/userstack'
  spec.license       = 'MIT'

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/feedforce/userstack'
    spec.metadata['changelog_uri'] = 'https://github.com/feedforce/userstack/Chengelog.md'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.52.x'
  spec.add_development_dependency 'webmock'
end
