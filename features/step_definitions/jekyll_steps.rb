include Test::Unit::Assertions

When /^I run Jekyll$/ do
  run_jekyll
end

Then /^Jekyll should throw a "(.+)"$/ do |error_class|
  assert_raise(Object.const_get(error_class)) { run_jekyll }
end

Given /^I have a configuration with:$/ do |config|
  write_file('_config.yml', config)
end

Given /^I have a responsive_image configuration with:$/ do |config|
  write_file('_config.yml', "responsive_image:\n#{config}")
end

Given /^I have a responsive_image configuration with "(.+)" set to "(.+)"$/ do |config, value|
  write_file('_config.yml', "responsive_image:\n  #{config}: #{value}")
end

Given /^I have a file "(.+)" with:$/ do |path, contents|
  write_file(path, "---\n---\n#{contents}")
end

Given /^I have a file "(.+)" with "(.+)"$/ do |path, contents|
  write_file(path, "---\n---\n#{contents}")
end

Then /^I should see "(.+)" in "(.*)"$/ do |text, file|
  assert_match(Regexp.new(text), File.open(file).readlines.join)
end

Then /^the file "(.+)" should exist$/ do |path|
  assert File.exists?(path)
end

Then /^the image "(.+)" should have the dimensions "(\d+)x(\d+)"$/ do |path, width, height|
  img = Magick::Image::read(path).first
  assert_equal "#{width}x#{height}", "#{img.columns}x#{img.rows}"
  img.destroy!
end

def write_file(path, contents)
  File.open(path, 'w') do |f|
    f.write(contents)
    f.close
  end
end
