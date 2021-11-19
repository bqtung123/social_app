source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.4'
gem 'puma',       '5.3.1'
gem 'sass-rails', '6.0.0'
gem 'webpacker',  '5.4.0'
gem 'turbolinks', '5.2.1'
gem 'jbuilder',   '2.10.0'
gem 'bootsnap',   '1.7.2', require: false
gem 'mysql2'
gem 'bootstrap-sass', '~> 3.3', '>= 3.3.6'
gem 'sprockets', '~> 3.5', '>= 3.5.2'
gem 'rails-controller-testing'
gem 'bcrypt'
gem 'faker', '~> 1.6', '>= 1.6.3'
gem 'will_paginate', '~> 3.1', '>= 3.1.6'
gem 'bootstrap-will_paginate', '~> 1.0'
gem 'carrierwave',             '0.10.0'
gem 'mini_magick', '~> 4.5', '>= 4.5.1'
gem 'fog',                     '1.36.0'

gem "figaro"
gem 'omniauth-google-oauth2','0.8.2'
gem 'omniauth', '~> 1.6', '>= 1.6.1'
gem "omniauth-facebook"
gem 'rubocop'
gem 'rubocop-performance'
gem 'rubocop-rails'
group :development, :test do
  gem 'sqlite3', '1.4.2'
  gem 'byebug',  '11.1.3', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console',        '4.1.0'
  gem 'rack-mini-profiler', '2.3.1'
  gem 'listen',             '3.4.1'
  gem 'spring',             '2.1.1'
end

group :test do
  gem 'capybara',           '3.35.3'
  gem 'selenium-webdriver', '3.142.7'
  gem 'webdrivers',         '4.6.0'
end

group :production do
  gem 'pg', '1.2.3'
end
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]