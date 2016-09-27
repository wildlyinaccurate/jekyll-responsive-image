if ENV['CI']
  require 'coveralls'
  Coveralls.wear!
end

require 'test/unit/assertions'
require 'jekyll/responsive_image'

TEST_DIR = File.join('/', 'tmp', 'jekyll')

def run_jekyll(options = {})
  options = Jekyll.configuration(options)

  site = Jekyll::Site.new(options)
  site.process
end

World(Test::Unit::Assertions)
