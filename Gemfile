source 'https://rubygems.org/'
gemspec

group :development do
  gem 'rake'
  gem 'cucumber', '~> 2.4'
  gem 'test-unit', '~> 3.1', require: false
  gem 'rubocop', '~> 0.43', require: false
  gem 'coveralls', require: false

  platform :ruby_18, :ruby_19 do
    gem 'simplecov', '>= 0.10', '< 0.12'
  end
end
