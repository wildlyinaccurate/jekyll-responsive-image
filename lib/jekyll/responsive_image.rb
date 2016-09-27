require 'fileutils'
require 'yaml'

require 'jekyll'
require 'rmagick'

require 'jekyll/responsive_image/version'
require 'jekyll/responsive_image/config'
require 'jekyll/responsive_image/render_cache'
require 'jekyll/responsive_image/image'
require 'jekyll/responsive_image/image_processor'
require 'jekyll/responsive_image/image_resizer'
require 'jekyll/responsive_image/renderer'
require 'jekyll/responsive_image/tag'
require 'jekyll/responsive_image/block'
require 'jekyll/responsive_image/extra_image_generator'

Liquid::Template.register_tag('responsive_image', Jekyll::ResponsiveImage::Tag)
Liquid::Template.register_tag('responsive_image_block', Jekyll::ResponsiveImage::Block)
