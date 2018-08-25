# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'jekyll-responsive-image/version'

Gem::Specification.new do |spec|
  spec.name          = 'jekyll-responsive-image'
  spec.version       = Jekyll::ResponsiveImage::VERSION
  spec.authors       = ['Joseph Wynn']
  spec.email         = ['joseph@wildlyinaccurate.com']
  spec.summary       = 'Responsive image management for Jekyll'
  spec.homepage      = 'https://github.com/wildlyinaccurate/jekyll-responsive-image'
  spec.licenses      = ['MIT']
  spec.description   = %q{
    Highly configurable Jekyll plugin for managing responsive images. Automatically
    resizes images and provides a Liquid template tag for loading the images with
    picture, img srcset, Imager.js, etc.
  }

  spec.files         = `git ls-files -z lib/`.split("\u0000")
  spec.executables   = []
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'jekyll', ['>= 2.0', "< 4.0"]
  spec.add_runtime_dependency 'mini_magick', '~> 4.8'
  spec.add_runtime_dependency 'fastimage', '~> 2.1'
end
