Before do
  FileUtils.rm_rf(TEST_DIR) if File.exist?(TEST_DIR)
  FileUtils.mkdir_p(TEST_DIR)

  fixtures = File.expand_path('../../fixtures', __FILE__)
  FileUtils.cp_r(Dir.glob("#{fixtures}/*"), TEST_DIR)

  Dir.chdir(TEST_DIR)
end

at_exit do
  FileUtils.rm_rf(TEST_DIR) if File.exist?(TEST_DIR)
end
