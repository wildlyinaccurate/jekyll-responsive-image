When /^I run Jekyll$/ do
  run_jekyll
end

Then /^Jekyll should throw a "(.+)"$/ do |error_class|
  assert_raise(Object.const_get(error_class)) { run_jekyll }
end

Then /^there should be no errors$/ do
  # Implicit pass
end

Given /^I have copied my site to "(.+)"$/ do |path|
  new_site_dir = File.join(TEST_DIR, path)

  FileUtils.mkdir_p(new_site_dir)

  Dir.glob(File.join(TEST_DIR, '*'))
    .reject { |f| File.basename(f) == File.dirname(path) }
    .each { |f| FileUtils.mv(f, new_site_dir) }
end

Given /^I have no configuration$/ do
  write_file('_config.yml', '')
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
  contents = File.open(file).readlines.join
  assert contents.inspect.include?(text), "Expected to find #{text.inspect} in #{contents.inspect}"
end

Then /^the file "(.+)" should contain:$/ do |file, contents|
  assert_equal contents.strip, File.open(file).readlines.join.strip
end

Then /^the file "(.+)" should exist$/ do |path|
  assert File.exist?(path)
end

Then /^the file "(.+)" should not exist$/ do |path|
  assert !File.exist?(path)
end

Then /^the image "(.+)" should have the dimensions "(\d+)x(\d+)"$/ do |path, width, height|
  img = Magick::Image::read(path).first
  assert_equal "#{width}x#{height}", "#{img.columns}x#{img.rows}"
  img.destroy!
end

Then /^the image "(.+)" should be interlaced$/ do |path|
  img = Magick::Image::read(path).first
  assert_equal Magick::JPEGInterlace, img.interlace
  img.destroy!
end

Then /^the image "(.+)" should have an EXIF orientation$/ do |path|
  img = Magick::Image::read(path).first
  assert_not_equal img.orientation.to_i, 0
  img.destroy!
end

Then /^the image "(.+)" should have no EXIF orientation$/ do |path|
  img = Magick::Image::read(path).first
  assert_equal img.orientation.to_i, 0
  img.destroy!
end

def write_file(path, contents)
  File.open(path, 'w') do |f|
    f.write(contents)
    f.close
  end
end
