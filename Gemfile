source 'https://rubygems.org'

# Declare your gem's dependencies in errdo.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use a debugger
gem "appraisal"
gem "codeclimate-test-reporter", group: :test, require: nil

group :development, :test do
  gem 'factory_girl'
  gem 'pry'
  gem 'pry-byebug'
  gem 'mini_backtrace'
  gem 'minitest-reporters'
  gem 'shoulda-context'
  gem 'shoulda-matchers', '~> 2.0' # Hasn't been updated to work with new shoulda. Check back.
  # gem 'guard'
  # gem 'guard-minitest'
  gem 'cancancan'
  gem 'devise' # To test logged in user tracking
  gem 'simplecov', require: false
end

group :development do
  gem 'rubocop'
end
