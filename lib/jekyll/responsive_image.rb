require 'jekyll'
require 'rmagick'

require 'jekyll/responsive_image/version'
require 'jekyll/responsive_image/defaults'
require 'jekyll/responsive_image/tag'

Liquid::Template.register_tag('responsive_image', Jekyll::ResponsiveImage::Tag)
