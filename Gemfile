source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.2"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem "bcrypt"
gem "bootsnap", "1.7.2", require: false
gem "bootstrap-sass", "~> 3.3", ">= 3.3.6"
gem "bootstrap-will_paginate", "~> 1.0"
gem "carrierwave",             "0.10.0"
gem "faker", "~> 1.6", ">= 1.6.3"
gem "fog", "1.36.0"
gem "jbuilder", "2.10.0"
gem "mini_magick", "~> 4.5", ">= 4.5.1"

gem "puma", "5.3.1"
gem "rails", "~> 6.1.4"
gem "rails-controller-testing"
gem "sass-rails", "6.0.0"
gem "sprockets", "~> 3.5", ">= 3.5.2"
gem "webpacker", "5.4.0"
gem "will_paginate", "~> 3.1", ">= 3.1.6"

gem "figaro"
gem "omniauth", "~> 1.6", ">= 1.6.1"
gem "omniauth-facebook"
gem "omniauth-google-oauth2", "0.8.2"
gem "rubocop"
gem "rubocop-performance"
gem "rubocop-rails"

gem "acts_as_votable"
gem "by_star"
gem "cancancan"
gem "devise"
gem "factory_bot"
gem "faraday"
gem "jquery-rails"
gem "prettier"
gem "pry-rails", group: :development
gem "rolify"
gem "rubyzip", require: "zip"
gem "slack-api"
gem "slack-notifier"
gem "slack-ruby-client"
gem "turbo-rails"
gem "whenever", require: false
group :development, :test do
  gem "byebug", "11.1.3", platforms: [:mri, :mingw, :x64_mingw]
  gem "mysql2"
  gem "rspec-rails", "~> 4.0.0"
  gem "sqlite3", "1.4.2"
  gem "webmock"
end

group :development do
  gem "listen",             "3.4.1"
  gem "rack-mini-profiler", "2.3.1"
  gem "spring",             "2.1.1"
  gem "web-console",        "4.1.0"
end

group :test do
  gem "capybara",           "3.35.3"
  gem "selenium-webdriver", "3.142.7"
  gem "webdrivers",         "4.6.0"
end

group :production do
  gem "pg", "1.2.3"
  gem "rails_12factor"
end
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
# Use Redis for Action Cable
gem "redis", "~> 4.0"

gem "noticed", "~> 1.5"

gem "stimulus-rails", "~> 1.0"
