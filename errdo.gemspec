$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'errdo/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'errdo'
  s.version     = Errdo::VERSION
  s.authors     = ['erichaydel']
  s.email       = ['erichaydel@gmail.com']
  s.homepage    = 'https://github.com/erichaydel/errdo'
  s.summary     = "Errdo allows developers to keep track of their users' experience on their site, simply and easily"
  s.description = 'A simple plugin to handle, log, and customize production errors'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '>= 4.1.0'
  s.add_dependency 'slim-rails', '>= 3.0'
  s.add_dependency 'chartkick', '~> 2.2', '>= 2.2.0'
  s.add_dependency 'sass-rails', '>= 3.2'
  s.add_dependency 'kaminari', '~> 1.0', '>= 1.0.1'
  s.add_dependency 'slack-notifier'

  s.add_development_dependency "activerecord"
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'webmock'
end
