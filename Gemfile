source 'https://rubygems.org'

gem 'rails', '4.0.2'
gem 'instagram'

gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'

gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'

gem 'turbolinks'
gem 'jbuilder', '~> 1.2'

gem 'pg'
gem 'whenever'
gem 'geocoder'
gem 'database_cleaner'
gem 'httparty'

#analytics
gem 'newrelic_rpm'

# web server
gem 'unicorn'
gem 'unicorn-rails'

# caching funsies
gem 'redis'
gem 'redis-rack-cache'

# cors
gem 'rack-cors', :require => 'rack/cors'

group :doc do
  gem 'sdoc', require: false
end

group :production do
  gem 'rails_12factor'
end

group :development do
  gem 'redis-rails'
  gem 'rack-cache'
end

group :development, :test do
  gem 'spork-rails', '4.0.0'
  gem 'childprocess', '0.3.9'
  gem 'debugger'
  gem 'rspec-rails'
end

group :test do
  gem 'selenium-webdriver'
  gem 'capybara'
  gem 'factory_girl_rails', '4.2.1'
  gem 'shoulda-matchers'
end

