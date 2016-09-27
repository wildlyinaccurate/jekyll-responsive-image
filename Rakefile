require 'bundler'
require 'rubocop/rake_task'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rake'
require 'jekyll/responsive_image/version'
require 'cucumber/rake/task'
require 'coveralls/rake/task'

RuboCop::RakeTask.new

Cucumber::Rake::Task.new(:features)

Coveralls::RakeTask.new
task :features_with_coveralls => [:features, 'coveralls:push']

task :default => [:rubocop, :features]

task :release do |t|
  system "gem build jekyll-responsive_image.gemspec"
  system "git tag v#{Jekyll::ResponsiveImage::VERSION} -a -m 'Tagged release of jekyll-responsive_image-#{Jekyll::ResponsiveImage::VERSION}.gem'"
  system "git push --tags"
  system "gem push jekyll-responsive_image-#{Jekyll::ResponsiveImage::VERSION}.gem"
end
