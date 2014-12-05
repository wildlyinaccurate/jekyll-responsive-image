# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'jekyll/responsive_image/version'

Gem::Specification.new do |spec|
  spec.name          = 'jekyll-responsive-image'
  spec.version       = Jekyll::ResponsiveImage::VERSION
  spec.authors       = ['Joseph Wynn']
  spec.email         = ['joseph@wildlyinaccurate.com']
  spec.summary       = 'Responsive images for Jekyll via srcset'
  spec.homepage      = 'https://github.com/wildlyinaccurate/jekyll-responsive-image'
  spec.licenses      = ['MIT']
  spec.description   = %q{

  }

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = []
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'jekyll', '~> 2.0'
  spec.add_runtime_dependency 'rmagick'
end
