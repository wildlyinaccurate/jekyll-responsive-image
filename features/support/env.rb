require 'simplecov'
require 'coveralls'

formatters = [SimpleCov::Formatter::HTMLFormatter]
formatters << Coveralls::SimpleCov::Formatter if ENV['CI']

SimpleCov.formatters = formatters
SimpleCov.start

require 'test/unit/assertions'
require 'jekyll-responsive-image'

TEST_DIR = File.join('/', 'tmp', 'jekyll')

def run_jekyll(options = {})
  options = Jekyll.configuration(options)

  site = Jekyll::Site.new(options)
  site.process
end

World(Test::Unit::Assertions)
