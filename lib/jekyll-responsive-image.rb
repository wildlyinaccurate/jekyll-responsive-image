require 'fileutils'
require 'yaml'

require 'jekyll'
require 'mini_magick'
require 'fastimage'

require 'jekyll-responsive-image/version'
require 'jekyll-responsive-image/config'
require 'jekyll-responsive-image/utils'
require 'jekyll-responsive-image/render_cache'
require 'jekyll-responsive-image/image_processor'
require 'jekyll-responsive-image/resize_handler'
require 'jekyll-responsive-image/renderer'
require 'jekyll-responsive-image/tag'
require 'jekyll-responsive-image/block'
require 'jekyll-responsive-image/extra_image_generator'

Liquid::Template.register_tag('responsive_image', Jekyll::ResponsiveImage::Tag)
Liquid::Template.register_tag('responsive_image_block', Jekyll::ResponsiveImage::Block)
