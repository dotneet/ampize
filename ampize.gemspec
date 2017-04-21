# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ampize/version'

Gem::Specification.new do |spec|
  spec.name          = "ampize"
  spec.version       = Ampize::VERSION
  spec.authors       = ["devneko"]
  spec.email         = ["dotneet@gmail.com"]

  spec.summary       = %q{transform plain html to Google AMP html.}
  spec.description   = %q{ampize replace tags to AMP specific tags and remove prohibited tags and attributes.}
  spec.homepage      = "https://github.com/dotneet/ampize"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'fastimage', '~> 2.0'
  spec.add_dependency 'nokogiri', '= 1.6.8.1'

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
