# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'jekyll/responsive_image/version'

Gem::Specification.new do |spec|
  spec.name          = 'jekyll-responsive_image'
  spec.version       = Jekyll::ResponsiveImage::VERSION
  spec.authors       = ['Joseph Wynn']
  spec.email         = ['joseph@wildlyinaccurate.com']
  spec.summary       = 'Responsive images for Jekyll via srcset'
  spec.homepage      = 'https://github.com/wildlyinaccurate/jekyll-responsive-image'
  spec.licenses      = ['MIT']
  spec.description   = %q{
    Jekyll Responsive Images is a Jekyll plugin and utility for automatically resizing images.
    Its intended use is for sites which want to display responsive images using something like srcset or Imager.js.
  }

  spec.files        = `git ls-files`.split($/)
  spec.test_files   = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables  = []
  spec.require_path = 'lib'

  spec.add_runtime_dependency 'jekyll', '~> 2.0'
  spec.add_runtime_dependency 'rmagick'
end
