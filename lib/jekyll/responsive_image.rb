require 'fileutils'
require 'yaml'

require 'jekyll'
require 'rmagick'

require 'jekyll/responsive_image/version'
require 'jekyll/responsive_image/defaults'
require 'jekyll/responsive_image/utils'
require 'jekyll/responsive_image/image_processor'
require 'jekyll/responsive_image/resize_handler'
require 'jekyll/responsive_image/common'
require 'jekyll/responsive_image/tag'
require 'jekyll/responsive_image/block'

Liquid::Template.register_tag('responsive_image', Jekyll::ResponsiveImage::Tag)
Liquid::Template.register_tag('responsive_image_block', Jekyll::ResponsiveImage::Block)
